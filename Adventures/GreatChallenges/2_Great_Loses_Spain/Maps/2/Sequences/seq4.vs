Building this;
Settlement set;
ObjList all_defenders_1, all_defenders_2, defenders_outside_1, defenders_outside_2, enemies;
Unit u;
point pt_pos, pt_1, pt_2;
rect rc;
int i, j, plr, rng, rng_half, max_def_out_1, max_def_out_2, old_level_1, old_level_2, end_level_1, end_level_2, start_time_1, start_time_2, interval_1, interval_2;

Sleep(750 + rand(751));

this = ROutpost5.obj.AsBuilding();
set = .settlement;

rc = GetMapRect();

pt_pos = .pos;
plr = .player;
rng = .range;
rng_half = rng / 2;

{
	str def_class_1, def_class_2;
	int def_amount_1, def_amount_2;

	def_class_1 = "RVelit";
	def_class_2 = "RPraetorian";

	def_amount_1 = 33;
	def_amount_2 = 21;

	max_def_out_1 = 11;
	max_def_out_2 = 7;

	old_level_1 = 10;
	old_level_2 = 10;

	end_level_1 = 24;
	end_level_2 = 24;

	if (end_level_1 > old_level_1)
		interval_1 = 3600000 / (end_level_1 - old_level_1);

	if (end_level_2 > old_level_2)
		interval_2 = 3600000 / (end_level_2 - old_level_2);

	start_time_1 = GetTime();
	start_time_2 = start_time_1;

	for (i = 0; i < def_amount_1; i += 1) {
		u = Place(def_class_1, pt_pos, plr).AsUnit();
		set.ForceAddUnit(u);
		u.SetFeeding(false);
		u.SetLevel(old_level_1);
		u.SetNoAIFlag(true);
		all_defenders_1.Add(u);
	}
	for (i = 0; i < def_amount_2; i += 1) {
		u = Place(def_class_2, pt_pos, plr).AsUnit();
		set.ForceAddUnit(u);
		u.SetFeeding(false);
		u.SetLevel(old_level_2);
		u.SetNoAIFlag(true);
		all_defenders_2.Add(u);
	}
}

while (plr == .player) {
	if (set.loyalty < 100)
		set.SetLoyalty(100);

	if (interval_1 > 0) {
		j = GetTime();
		if (j - start_time_1 >= interval_1)
			if (old_level_1 < end_level_1) {
				start_time_1 = j;
				old_level_1 += 1;
			}
			else
				interval_1 = 0;
	}
	if (interval_2 > 0) {
		j = GetTime();
		if (j - start_time_2 >= interval_2)
			if (old_level_2 < end_level_2) {
				start_time_2 = j;
				old_level_2 += 1;
			}
			else
				interval_2 = 0;
	}

	for (i = all_defenders_1.count - 1; i >= 0; i -= 1) {
		u = all_defenders_1[i].AsUnit();
		if (u.IsDead)
			all_defenders_1.Remove(u);
		else if (u.inherentlevel < old_level_1)
			u.SetLevel(old_level_1);
	}
	for (i = all_defenders_2.count - 1; i >= 0; i -= 1) {
		u = all_defenders_2[i].AsUnit();
		if (u.IsDead)
			all_defenders_2.Remove(u);
		else if (u.inherentlevel < old_level_2)
			u.SetLevel(old_level_2);
	}

	enemies = Union(
		Intersect(
			VisibleObjsInSight(this, "Military,BaseMage"),
			Subtract(
				Intersect(
					ObjsInRange(this, "Unit", rng),
					Union(EnemyObjs(plr, "Military"), EnemyObjs(plr, "BaseMage"))
				),
				EnemyObjs(plr, "Sentry")
			)
		),
		Intersect(ObjsInRange(this, "Catapult", rng), EnemyObjs(plr, "Catapult"))
	).GetObjList();

	if (enemies.count <= 0) {//no threat around, command all units that are out to come back in
		defenders_outside_1.SetCommand("guard_enter", this);
		defenders_outside_1.Clear();
		defenders_outside_2.SetCommand("guard_enter", this);
		defenders_outside_2.Clear();
	}
	else {
		for (i = defenders_outside_1.count - 1; i >= 0; i -= 1) {//do not allow units to wander too far
			u = defenders_outside_1[i].AsUnit();
			if (u.IsDead)
				defenders_outside_1.Remove(u);
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
					u.AddCommand(false, "guard_patrol", pt_2);
				}
			}
		}
		for (i = defenders_outside_2.count - 1; i >= 0; i -= 1) {//do not allow units to wander too far
			u = defenders_outside_2[i].AsUnit();
			if (u.IsDead)
				defenders_outside_2.Remove(u);
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
					u.AddCommand(false, "guard_patrol", pt_2);
				}
			}
		}

		for (i = all_defenders_1.count - 1; i >= 0; i -= 1) {//get out more units if needed
			u = all_defenders_1[i].AsUnit();
			if (u.IsDead)
				all_defenders_1.Remove(u);
			else if (defenders_outside_1.count < max_def_out_1)
				if (u.InHolder) {
					defenders_outside_1.Add(u);
					pt_1.Set(0, rng_half);
					pt_1.Rot(rand(360));
					pt_2 = pt_1 + pt_pos;
					pt_2.IntoRect(rc);
					u.SetCommand("guard_advance", pt_2);
					for (j = 0; j < 4; j += 1) {
						pt_1.Rot(90);
						pt_2 = pt_1 + pt_pos;
						pt_2.IntoRect(rc);
						u.AddCommand(false, "guard_patrol", pt_2);
					}
				}
		}
		for (i = all_defenders_2.count - 1; i >= 0; i -= 1) {//get out more units if needed
			u = all_defenders_2[i].AsUnit();
			if (u.IsDead)
				all_defenders_2.Remove(u);
			else if (defenders_outside_2.count < max_def_out_2)
				if (u.InHolder) {
					defenders_outside_2.Add(u);
					pt_1.Set(0, rng_half);
					pt_1.Rot(rand(360));
					pt_2 = pt_1 + pt_pos;
					pt_2.IntoRect(rc);
					u.SetCommand("guard_advance", pt_2);
					for (j = 0; j < 4; j += 1) {
						pt_1.Rot(90);
						pt_2 = pt_1 + pt_pos;
						pt_2.IntoRect(rc);
						u.AddCommand(false, "guard_patrol", pt_2);
					}
				}
		}

		if (all_defenders_1.count <= 0)//handle the capturing (the new player will be chosen randomly among those with most warriors nearby)
			if (all_defenders_2.count <= 0) {
				enemies = enemies.ObjClass("Military");
				enemies.ClearDead();
				i = enemies.count;
				if (i > 0) {
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

	Sleep(1000);
}