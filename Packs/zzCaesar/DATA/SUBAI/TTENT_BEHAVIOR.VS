//void, Obj This

Building this;
Settlement set;
ObjList all_defenders, defenders_1, defenders_2, defenders_outside, enemies;
Unit u;
point pos, pt1, pt2;
rect rc;
str unit_class_1, unit_class_2;
int i, j, player, radius, sight, initial_army, active_army, spawn_rate, last_spawn_time, delay, exp_gain, old_exp_gain;
bool first_time_independent;

Sleep(rand(1001) + 500);

this = This.AsBuilding();

set = .settlement;

set.SetLoyalty(100);//impossible to capture until the garrison is defeated

rc = GetMapRect();

player = .player;
radius = .radius + 150;
sight = .sight;
pos = .pos;

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

while (1) {
	if (player != .player) {//this lets the old units recapture the tent (it should happen only with adventure sequences)
		defenders_1.Clear();
		defenders_2.Clear();
		defenders_outside.Clear();
		if (player != 15)//independent "non-rescue" units must not starve (16 = rescue)
			for (i = all_defenders.count - 1; i >= 0; i -= 1) {
				u = all_defenders[i].AsUnit();
				if (u.IsValid)
					if (u.IsAlive)
						u.SetFeeding(true);
			}
		all_defenders.Clear();
		player = .player;
	}

	//send away enemy units inside
	pt1 = Point(radius, 0);
	pt1.Rot(rand(360));
	set.Units.ObjEnemy(player).SetCommand("advance", pt1 + pos);

	exp_gain = MAX(0, GetTime() / 120000 - 5);

	//spawn neutral or produced units
	if (set.IsIndependent) {
		defenders_1.ClearDead();
		defenders_2.ClearDead();
		while (last_spawn_time > spawn_rate) {
			last_spawn_time -= spawn_rate;
			if (defenders_1.count >= initial_army)
				if (defenders_2.count >= initial_army)
					break;
			if (defenders_1.count < initial_army) {
				u = Place(unit_class_1, pos, player).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetExperience(old_exp_gain);
				u.SetNoAIFlag(true);
				defenders_1.Add(u);
				all_defenders.Add(u);
			}
			if (defenders_2.count < initial_army) {
				u = Place(unit_class_2, pos, player).AsUnit();
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
	else if (delay >= spawn_rate) {
		str class_prod;
		class_prod = EnvReadString(set, "ENV_TProd");
		if (class_prod == "CLibyanFootman") {
			if (set.food >= 200) {
				set.SetFood(set.food - 200);
				u = Place(class_prod, pos, player).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetExperience(old_exp_gain);
				all_defenders.Add(u);
			}
		}
		else if (class_prod != "")
			if (set.food >= 400) {
				set.SetFood(set.food - 400);
				u = Place(class_prod, pos, player).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetExperience(old_exp_gain);
				all_defenders.Add(u);
			}
		delay = 0;
	}
	else
		delay += 1000;

	//set feeding of commanded units
	all_defenders.ClearDead();
	for (i = all_defenders.count - 1; i >= 0; i -= 1) {
		u = all_defenders[i].AsUnit();
		if (u.IsValid)
			if (u.GetCommanded()) {
				u.SetFeeding(true);
				all_defenders.Remove(u);
			}
	}
	defenders_outside.ClearDead();
	for (i = defenders_outside.count - 1; i >= 0; i -= 1) {
		u = defenders_outside[i].AsUnit();
		if (u.IsValid)
			if (u.GetCommanded()) {
				u.SetFeeding(true);
				defenders_outside.Remove(u);
			}
	}

	//increase experience
	if (exp_gain > 0)
		if (exp_gain > old_exp_gain) {
			for (i = all_defenders.count - 1; i >= 0; i -= 1) {
				u = all_defenders[i].AsUnit();
				if (u.IsValid)
					u.SetExperience(u.experience + exp_gain - old_exp_gain);
			}
			old_exp_gain = exp_gain;
		}

	defenders_outside.ClearDead();
	enemies = Intersect(
		VisibleObjsInSight(this, "Unit"),
		Subtract(
			Union(EnemyObjs(player, "Military"), EnemyObjs(player, "BaseMage")),
			EnemyObjs(player, "Sentry")
		)
	).GetObjList();
	if (enemies.count <= 0) {
		//no threat around, command all units that are out to come back in
		defenders_outside.SetCommand("enter_tent", this);
		defenders_outside.Clear();
	}
	else {
		//do not allow units to wander too far
		for (i = 0; i < defenders_outside.count; i += 1) {
			u = defenders_outside[i].AsUnit();
			if (.DistTo(u) > sight) {
				pt1 = u.pos - pos;
				pt1.SetLen(sight / 2);
				pt2 = pt1 + pos;
				pt2.IntoRect(rc);
				u.SetCommand("move", pt2);
				for (j = 0; j < 4; j += 1) {
					pt1.Rot(90);
					pt2 = pt1 + pos;
					pt2.IntoRect(rc);
					u.AddCommand(false, "patrol", pt2);
				}
			}
		}

		//get out more units if needed
		while (defenders_outside.count < active_army && set.UnitsCount > 0) {
			u = set.Units[0];
			defenders_outside.Add(u);
			pt1.Set(0, sight / 2);
			pt1.Rot(rand(360));
			pt2 = pt1 + pos;
			pt2.IntoRect(rc);
			u.SetCommand("advance", pt2);
			for (j = 0; j < 4; j += 1) {
				pt1.Rot(90);
				pt2 = pt1 + pos;
				pt2.IntoRect(rc);
				u.AddCommand(false, "patrol", pt2);
			}
		}

		//handle the capturing (the new owner will be chosen randomly among the players with most units nearby)
		all_defenders.ClearDead();
		if (all_defenders.count <= 0) {
			enemies.ClearDead();
			i = enemies.count;
			if (i > 0)
				if (Intersect(VisibleObjsInSight(this, "Unit"), FriendlyObjs(player, "Military")).IsEmpty()) {//exclude hidden allies (just like with capturable buildings)
					IntArray player_units, players;
					int max, p;
					for (j = 0; j < i; j += 1)
						player_units[enemies[j].player] += 1;//count units per player
					for (i = 1; i <= 16; i += 1) {
						j = player_units[i];
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
			int t;
			t = GetConst("TentCapturedArmy");
			j = .player;
			for (i = 0; i < t; i += 1) {
				u = Place(unit_class_1, pos, j).AsUnit();
				set.ForceAddUnit(u);
				u.SetExperience(old_exp_gain);
				u.SetFeeding(false);
				all_defenders.Add(u);
				u = Place(unit_class_2, pos, j).AsUnit();
				set.ForceAddUnit(u);
				u.SetExperience(old_exp_gain);
				u.SetFeeding(false);
				all_defenders.Add(u);
			}
			first_time_independent = false;
		}

	Sleep(1000);
}