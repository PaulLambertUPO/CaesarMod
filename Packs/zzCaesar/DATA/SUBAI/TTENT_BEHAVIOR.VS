//void, Obj This

Building this;
Settlement set;
ObjList all_defenders, defenders_1, defenders_2, defenders_outside, enemies;
Unit u;
point pt_pos, pt_1, pt_2;
rect rc;
str unit_class_1, unit_class_2;
int i, j, plr, rad, rng, rng_half, initial_army, active_army, spawn_rate, last_spawn_time, delay, exp_gain, old_exp_gain;
bool first_time_independent;

Sleep(750 + rand(751));

this = This.AsBuilding();

set = .settlement;

set.SetLoyalty(100);//impossible to capture until the garrison is defeated

rc = GetMapRect();

plr = .player;
rad = .radius + 150;
rng = .range;
rng_half = rng / 2;
pt_pos = .pos;

initial_army = GetConst("TentInitialArmy");
active_army = GetConst("TentActiveArmy");
spawn_rate = GetConst("TentUnitSpawnRate");

last_spawn_time = spawn_rate * initial_army / 2;//spawn half of the army at the beginning

first_time_independent = set.IsIndependent;

if (.class == "CTent") {
	unit_class_1 = "CLibyanFootman";
	unit_class_2 = "CHorseman";
}
else {
	unit_class_1 = "TTeutonRider";
	unit_class_2 = "TTeutonArcher";
}

while (true) {
	if (plr != .player) {//this lets the old units recapture the tent (it should happen only with adventure sequences)
		defenders_1.Clear();
		defenders_2.Clear();
		defenders_outside.Clear();
		if (plr != 15)//independent "non-rescue" units must not starve (16 = rescue)
			for (i = all_defenders.count - 1; i >= 0; i -= 1) {
				u = all_defenders[i].AsUnit();
				if (u.IsAlive)
					u.SetFeeding(true);
			}
		all_defenders.Clear();
		plr = .player;
	}

	pt_1.Set(rad, 0);
	pt_1.Rot(rand(360));
	set.Units.ObjEnemy(plr).SetCommand("advance", pt_1 + pt_pos);//send away enemy units inside

	if (set.IsIndependent) {//spawn neutral units
		defenders_1.ClearDead();
		defenders_2.ClearDead();
		while (last_spawn_time > spawn_rate) {
			last_spawn_time -= spawn_rate;
			if (defenders_1.count >= initial_army)
				if (defenders_2.count >= initial_army)
					break;
			if (defenders_1.count < initial_army) {
				u = Place(unit_class_1, pt_pos, plr).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetExperience(old_exp_gain);
				u.SetNoAIFlag(true);
				defenders_1.Add(u);
				all_defenders.Add(u);
			}
			if (defenders_2.count < initial_army) {
				u = Place(unit_class_2, pt_pos, plr).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetExperience(old_exp_gain);
				u.SetNoAIFlag(true);
				defenders_2.Add(u);
				all_defenders.Add(u);
			}
		}
		last_spawn_time += 1000;
	}
	else if (delay >= spawn_rate) {//spawn produced units
		str class_prod;
		class_prod = EnvReadString(set, "ENV_TProd");
		if (class_prod == "CLibyanFootman") {
			if (set.food >= 200) {
				set.SetFood(set.food - 200);
				u = Place(class_prod, pt_pos, plr).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetExperience(old_exp_gain);
				all_defenders.Add(u);
			}
		}
		else if (class_prod != "")
			if (set.food >= 400) {
				set.SetFood(set.food - 400);
				u = Place(class_prod, pt_pos, plr).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetExperience(old_exp_gain);
				all_defenders.Add(u);
			}
		delay = 0;
	}
	else
		delay += 1000;

	for (i = all_defenders.count - 1; i >= 0; i -= 1) {//set feeding of commanded units
		u = all_defenders[i].AsUnit();
		if (u.IsDead)
			all_defenders.Remove(u);
		else if (u.GetCommanded()) {
			u.SetFeeding(true);
			all_defenders.Remove(u);
		}
	}

	exp_gain = GetTime() / 60000 - 4;//start gaining experience after 5 minutes
	if (exp_gain > old_exp_gain) {
		for (i = all_defenders.count - 1; i >= 0; i -= 1) {
			u = all_defenders[i].AsUnit();
			if (u.IsDead)
				all_defenders.Remove(u);
			else
				u.SetExperience(u.experience + exp_gain - old_exp_gain);
		}
		old_exp_gain = exp_gain;
	}

	enemies = Intersect(
		VisibleObjsInSight(this, "Military,BaseMage"),
		Subtract(
			Union(EnemyObjs(plr, "Military"), EnemyObjs(plr, "BaseMage")),
			EnemyObjs(plr, "Sentry")
		)
	).GetObjList();

	if (enemies.count <= 0) {//no threat around, command all units that are out to come back in
		defenders_outside.SetCommand("enter_tent", this);
		defenders_outside.Clear();
	}
	else {
		for (i = defenders_outside.count - 1; i >= 0; i -= 1) {//do not allow units to wander too far
			u = defenders_outside[i].AsUnit();
			if (u.IsDead)
				defenders_outside.Remove(u);
			else if (.DistTo(u) > rng) {
				pt_1 = u.pos - pt_pos;
				pt_1.SetLen(rng_half);
				pt_2 = pt_1 + pt_pos;
				pt_2.IntoRect(rc);
				u.SetCommand("move", pt_2);
				for (j = 0; j < 4; j += 1) {
					pt_1.Rot(90);
					pt_2 = pt_1 + pt_pos;
					pt_2.IntoRect(rc);
					u.AddCommand(false, "guardpatrol", pt_2);
				}
			}
		}

		for (i = all_defenders.count - 1; i >= 0; i -= 1) {//get out more units if needed
			u = all_defenders[i].AsUnit();
			if (u.IsDead)
				all_defenders.Remove(u);
			else if (defenders_outside.count < active_army)
				if (u.InHolder) {
					defenders_outside.Add(u);
					pt_1.Set(0, rng_half);
					pt_1.Rot(rand(360));
					pt_2 = pt_1 + pt_pos;
					pt_2.IntoRect(rc);
					u.SetCommand("guardadvance", pt_2);
					for (j = 0; j < 4; j += 1) {
						pt_1.Rot(90);
						pt_2 = pt_1 + pt_pos;
						pt_2.IntoRect(rc);
						u.AddCommand(false, "guardpatrol", pt_2);
					}
				}
		}

		if (all_defenders.count <= 0) {//handle the capturing (the new player will be chosen randomly among those with most warriors nearby)
			enemies = enemies.ObjClass("Military");
			enemies.ClearDead();
			i = enemies.count;
			if (i > 0)
				if (Intersect(VisibleObjsInSight(this, "Unit"), FriendlyObjs(plr, "Military")).IsEmpty) {//exclude hidden allies (just like with capturable buildings)
					IntArray player_warriors, players;
					int max, p;
					for (j = 0; j < i; j += 1)
						player_warriors[enemies[j].player] += 1;//count warriors per player
					for (i = 1; i <= 16; i += 1) {
						j = player_warriors[i];
						if (j > 0)
							if (j > max) {//new max found, reset the players to choose from
								max = j;
								players.resize(0);
								players[0] = i;
								p = 1;
							}
							else if (j == max) {//add one more player to choose from
								players[p] = i;
								p += 1;
							}
					}
					if (p > 0)
						.SetPlayer(players[rand(p)]);
				}
		}
	}

	if (first_time_independent)//spawn some units for the new player (only once)
		if (!set.IsIndependent) {//avoid giving units/resources to possible neutral units coming from other outposts
			j = GetConst("TentCapturedArmy");
			plr = .player;
			for (i = 0; i < j; i += 1) {
				u = Place(unit_class_1, pt_pos, plr).AsUnit();
				set.ForceAddUnit(u);
				u.SetExperience(old_exp_gain);
				u.SetFeeding(false);
				all_defenders.Add(u);
				u = Place(unit_class_2, pt_pos, plr).AsUnit();
				set.ForceAddUnit(u);
				u.SetExperience(old_exp_gain);
				u.SetFeeding(false);
				all_defenders.Add(u);
			}
			first_time_independent = false;
		}

	Sleep(1000);
}