//void, Obj this

.Progress();

{
	Settlement set;
	Unit u;
	point pt_place;
	int i, plr, u_level;
	bool veteran_upgrade;

	set = .AsBuilding().settlement;
	plr = .player;

	if (GetTime() >= 600000)
		u_level = 8;
	else
		u_level = 4;

	veteran_upgrade = EnvReadInt(set, "items/Veteran Guild") != 0;

	if (set.IsStronghold) {
		pt_place = .pos;

		for (i = 0; i < 50; i += 1) {
			u = Place("IMilitiaman", pt_place, plr).AsUnit();
			u.SetLevel(u_level);
			if (veteran_upgrade)
				u.AddItem("Veteran Guild");
			set.ForceAddUnit(u);
		}
	}
	else {
		pt_place = set.GetCentralBuilding().GetExitPoint(.pos, false);

		for (i = 0; i < 50; i += 1) {
			u = Place("IMilitiaman", pt_place, plr).AsUnit();
			u.SetLevel(u_level);
			if (veteran_upgrade)
				u.AddItem("Veteran Guild");
			u.SetCommand("advance", RandomPointInCircle(pt_place, 450));
		}
	}
}