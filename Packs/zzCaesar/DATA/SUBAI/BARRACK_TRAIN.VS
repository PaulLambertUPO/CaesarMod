//void, Obj This

Barrack this;
Settlement set;

this = This.AsBarrack();
set = .settlement;

.Progress(.cmddelay * (1000 - EnvReadInt(set, "BarrackTrainTimeDecrease")) / 1000);

{
	Building hall;
	Unit u;
	point exit_point;
	str u_class, s;
	int plr, u_level = 1;

	hall = set.GetCentralBuilding();
	u_class = ParseStr(cmdparam, s);
	plr = .player;

	exit_point = .GetExitPoint(hall.pos, false);
	if (exit_point.x == -1) {
		u = Place(u_class, Point(0, 0), plr).AsUnit();
		set.AddUnit(u);
	}
	else if (exit_point.y == -1) {
		u = Place(u_class, Point(0, 0), plr).AsUnit();
		set.AddUnit(u);
	}
	else {
		u = Place(u_class, exit_point, plr).AsUnit();
		u.SetCommand("advanceenter", hall);
	}

	if (!u.IsHeirOf("BaseMage")) {
		u_level = MAX(1, EnvReadInt(plr, "standard_spawn_level"));

		if (u_level < 12)
			if (IsResearched(set, "Shared Triumph")) {
				int c;
				c = Count(plr, u_class);
				if (c > 20)
					u_level = 12;
				else if (c > 10)
					if (u_level < 6)
						if (IsResearched(set, "Shared Strength"))
							u_level = 6;
			}
			else if (u_level < 6)
				if (IsResearched(set, "Shared Strength"))
					if (Count(plr, u_class) > 10)
						u_level = 6;

		if (u_level < 6)
			if (u.IsHeirOf("ICavalry"))
				if (IsResearched(plr, "Tame horses"))
					u_level = 6;

		if (u_level < 5)
			if (IsResearched(set, "Olympic Games"))
				u_level = 5;

		if (EnvReadInt(set, "items/Bear teeth amulet") == 1)
			u.AddItem("Bear teeth amulet");
		if (EnvReadInt(set, "items/Belt of might") == 1)
			u.AddItem("Belt of might");
		if (EnvReadInt(set, "items/Herb amulet of luck") == 1)
			u.AddItem("Herb amulet of luck");
		if (EnvReadInt(set, "items/God's Gift") == 1)
			u.AddItem("God's Gift");
		if (EnvReadInt(set, "items/Veteran Guild") == 1)
			u.AddItem("Veteran Guild");
	}

	u.SetLevel(MAX(u_level, EnvReadInt(set, "levels/" + u_class)));
}