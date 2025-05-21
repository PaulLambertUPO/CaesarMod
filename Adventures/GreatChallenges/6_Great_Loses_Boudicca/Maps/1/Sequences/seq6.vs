Building this;
Settlement set;
Query q_enemies;
ObjList ol_enemies, all_defenders_1, all_defenders_2, defenders_outside_1, defenders_outside_2;
Unit u;
point pos, pt1, pt2;
rect rc;
int i, j, range, player, old_level_1, old_level_2, end_level_1, end_level_2, start_time_1, start_time_2, interval_1, interval_2, time;
int defenders_max_1, defenders_max_2, defenders_out_1, defenders_out_2;
str defenders_class_1, defenders_class_2;

this = BritonOutpost1.obj.AsBuilding();

set = .settlement;

rc = GetMapRect();

range = .range;
player = .player;
pos = .pos;

defenders_max_1 = 10;
defenders_max_2 = 24;

defenders_out_1 = 5;
defenders_out_2 = 12;

defenders_class_1 = "BVikingLord";
defenders_class_2 = "BBowman";

old_level_1 = 8;
old_level_2 = 8;

end_level_1 = 12;
end_level_2 = 12;

if (end_level_1 != old_level_1)
	interval_1 = 3600000 / (end_level_1 - old_level_1);

if (end_level_2 != old_level_2)
	interval_2 = 3600000 / (end_level_2 - old_level_2);

start_time_1 = GetTime();
start_time_2 = start_time_1;

q_enemies = Union(
	Subtract(
		Intersect(
			ObjsInRange(this, "Unit", range),
			Union(EnemyObjs(player, "Military"), EnemyObjs(player, "BaseMage"))
		),
		EnemyObjs(player, "Sentry")
	),
	Intersect(ObjsInRange(this, "Building", range), EnemyObjs(player, "Catapult"))
);

for (i = 0; i < defenders_max_1; i += 1) {
	u = Place(defenders_class_1, pos, player);
	set.ForceAddUnit(u);
	u.SetFeeding(false);
	u.SetLevel(old_level_1);
	all_defenders_1.Add(u);
}
for (i = 0; i < defenders_max_2; i += 1) {
	u = Place(defenders_class_2, pos, player);
	set.ForceAddUnit(u);
	u.SetFeeding(false);
	u.SetLevel(old_level_2);
	all_defenders_2.Add(u);
}

while (1) {
	set.SetLoyalty(100);//impossible to capture until the garrison is defeated

	all_defenders_1.ClearDead();
	all_defenders_2.ClearDead();
	defenders_outside_1.ClearDead();
	defenders_outside_2.ClearDead();

	//increase level
	time = GetTime();
	if (interval_1 > 0)
		if (time - start_time_1 >= interval_1)
			if (old_level_1 + 1 <= end_level_1) {
				start_time_1 = time;
				old_level_1 += 1;
				for (i = all_defenders_1.count - 1; i >= 0; i -= 1) {
					u = all_defenders_1[i].AsUnit();
					if (u.IsValid)
						if (u.inherentlevel < old_level_1)
							u.SetLevel(old_level_1);
				}
			}
	if (interval_2 > 0)
		if (time - start_time_2 >= interval_2)
			if (old_level_2 + 1 <= end_level_2) {
				start_time_2 = time;
				old_level_2 += 1;
				for (i = all_defenders_2.count - 1; i >= 0; i -= 1) {
					u = all_defenders_2[i].AsUnit();
					if (u.IsValid)
						if (u.inherentlevel < old_level_2)
							u.SetLevel(old_level_2);
				}
			}

	ol_enemies = q_enemies.GetObjList();
	ol_enemies.ClearDead();
	if (ol_enemies.count <= 0) {
		//no threat around, command all units that are out to come back in
		defenders_outside_1.SetCommand("enter_tent", this);
		defenders_outside_1.Clear();
		defenders_outside_2.SetCommand("enter_tent", this);
		defenders_outside_2.Clear();
	}
	else {
		//do not allow defenders to wander too far
		for (i = 0; i < defenders_outside_1.count; i += 1) {
			u = defenders_outside_1[i].AsUnit();
			if (.DistTo(u) > range) {
				pt1 = u.pos - pos;
				pt1.SetLen(range / 2);
				pt2 = pt1 + pos;
				pt2.IntoRect(rc);
				u.SetCommand("move", pt2);
				for (j = 0; j < 4; j += 1) {
					pt1.Rot(90);
					pt2 = pt1 + pos;
					pt2.IntoRect(rc);
					u.AddCommand(false, "guardpatrol", pt2);
				}
			}
		}
		for (i = 0; i < defenders_outside_2.count; i += 1) {
			u = defenders_outside_2[i].AsUnit();
			if (.DistTo(u) > range) {
				pt1 = u.pos - pos;
				pt1.SetLen(range / 2);
				pt2 = pt1 + pos;
				pt2.IntoRect(rc);
				u.SetCommand("move", pt2);
				for (j = 0; j < 4; j += 1) {
					pt1.Rot(90);
					pt2 = pt1 + pos;
					pt2.IntoRect(rc);
					u.AddCommand(false, "guardpatrol", pt2);
				}
			}
		}

		//get out more units if needed
		all_defenders_1.ClearDead();
		if (all_defenders_1.count > 0) {
			defenders_outside_1.ClearDead();
			if (defenders_outside_1.count < defenders_out_1)
				for (i = 0; i < all_defenders_1.count && defenders_outside_1.count < defenders_out_1; i += 1) {
					u = all_defenders_1[i].AsUnit();
					if (u.InHolder) {
						defenders_outside_1.Add(u);
						pt1.Set(0, range / 2);
						pt1.Rot(rand(360));
						pt2 = pt1 + pos;
						pt2.IntoRect(rc);
						u.SetCommand("guardadvance", pt2);
						for (j = 0; j < 4; j += 1) {
							pt1.Rot(90);
							pt2 = pt1 + pos;
							pt2.IntoRect(rc);
							u.AddCommand(false, "guardpatrol", pt2);
						}
					}
				}
		}
		all_defenders_2.ClearDead();
		if (all_defenders_2.count > 0) {
			defenders_outside_2.ClearDead();
			if (defenders_outside_2.count < defenders_out_2)
				for (i = 0; i < all_defenders_2.count && defenders_outside_2.count < defenders_out_2; i += 1) {
					u = all_defenders_2[i].AsUnit();
					if (u.InHolder) {
						defenders_outside_2.Add(u);
						pt1.Set(0, range / 2);
						pt1.Rot(rand(360));
						pt2 = pt1 + pos;
						pt2.IntoRect(rc);
						u.SetCommand("guardadvance", pt2);
						for (j = 0; j < 4; j += 1) {
							pt1.Rot(90);
							pt2 = pt1 + pos;
							pt2.IntoRect(rc);
							u.AddCommand(false, "guardpatrol", pt2);
						}
					}
				}
		}

		//handle the capturing
		all_defenders_1.ClearDead();
		if (all_defenders_1.count <= 0) {
			all_defenders_2.ClearDead();
			if (all_defenders_2.count <= 0) {
				ol_enemies.ClearDead();
				i = ol_enemies.count;
				if (i > 0) {
					j = ol_enemies[rand(i)].player;
					if (j <= 8) {
						.SetPlayer(j);
						set.SetFood(.GetOutpostFood());
					}
				}
			}
		}

		if (player != .player)
			break;
	}
	Sleep(1000);
}