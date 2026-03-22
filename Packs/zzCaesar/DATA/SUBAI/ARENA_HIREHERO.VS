//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	Settlement set;
	Building hall;
	Hero h;
	point exit_point;
	int plr, h_level = 1;

	set = .settlement;
	hall = set.GetCentralBuilding();
	plr = .player;

	if (IsResearched(plr, "Mumification")) {
		ObjList ol;
		int i;

		h_level = EnvReadInt(plr, "BestHeroLevel");
		ol = GetPlayerUnits(plr, "Hero");
		for (i = ol.count - 1; i >= 0; i -= 1) {
			h = ol[i].AsHero();
			if (h.inherentlevel > h_level)
				h_level = h.inherentlevel;
		}
		h_level = MAX(1, h_level * 2 / 3);
	}

	exit_point = .GetExitPoint(hall.pos, false);
	if (exit_point.x == -1) {
		h = Place(GetRandomHeroClass(cmdparam, plr), Point(0, 0), plr).AsHero();
		set.AddUnit(h);
	}
	else if (exit_point.y == -1) {
		h = Place(GetRandomHeroClass(cmdparam, plr), Point(0, 0), plr).AsHero();
		set.AddUnit(h);
	}
	else {
		h = Place(GetRandomHeroClass(cmdparam, plr), exit_point, plr).AsHero();
		if (set.IsVillage)
			h.SetCommand("advance", hall.GetEnterPoint(h));
		else
			h.SetCommand("advanceenter", hall);
	}

	h.SetLevel(MAX(h_level, EnvReadInt(set, "levels/Hero")));
}