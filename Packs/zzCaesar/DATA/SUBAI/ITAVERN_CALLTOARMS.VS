//void, Obj this

.Progress();

{
	Settlement set;
	Unit u;
	point pt_pos;
	int i, plr, u_level;
	bool veteran_upgrade;

	set = .AsBuilding().settlement;
	pt_pos = .pos;
	plr = .player;

	veteran_upgrade = EnvReadInt(set, "items/Veteran Guild") != 0;

	if (GetTime() >= 600000)
		u_level = 8;
	else
		u_level = 4;

	for (i = 0; i < 50; i += 1) {
		u = Place("IMilitiaman", pt_pos, plr).AsUnit();
		u.SetLevel(u_level);
		if (veteran_upgrade)
			u.AddItem("Veteran Guild");
		set.ForceAddUnit(u);
	}
}