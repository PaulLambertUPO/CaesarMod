//void, Obj this

.Progress();

{
	Settlement set;
	Unit u;
	point pt_place;
	int i, plr;
	bool veteran_upgrade;

	set = .AsBuilding().settlement;
	plr = .player;

	veteran_upgrade = EnvReadInt(set, "items/Veteran Guild") != 0;

	if (set.IsStronghold) {
		pt_place = .pos;

		for (i = 0; i < 50; i += 1) {
			u = Place("IMilitiamanDesperate", pt_place, plr).AsUnit();
			u.SetLevel(8);
			if (veteran_upgrade)
				u.AddItem("Veteran Guild");
			set.ForceAddUnit(u);
		}
	}
	else {
		pt_place = set.GetCentralBuilding().GetExitPoint(.pos, false);

		for (i = 0; i < 50; i += 1) {
			u = Place("IMilitiamanDesperate", pt_place, plr).AsUnit();
			u.SetLevel(8);
			if (veteran_upgrade)
				u.AddItem("Veteran Guild");
			u.SetCommand("advance", RandomPointInCircle(pt_place, 450));
		}
	}
}