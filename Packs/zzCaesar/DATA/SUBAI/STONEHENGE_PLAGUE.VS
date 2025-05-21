//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList player_units;
	Unit u;
	int duration, base_divider, caster_divider, owning_player, secs, i, d, j, c;
	str zero_sec_marker;

	duration = GetConst("StonehengePlagueTime");
	base_divider = GetConst("StonehengePlagueBaseDivider");
	caster_divider = GetConst("StonehengePlagueCasterDivider");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	for (i = 1; i <= 16; i += 1) {
		if (i == owning_player)
			d = caster_divider;
		else
			d = base_divider;
		player_units = GetPlayerUnits(i);//there would be too much overhead to check the real player of every unit for the divider to work correctly (GetPlayerUnits takes units from other players that are attached to player i's heroes)
		player_units.ClearDead();
		c = player_units.count;
		for (j = 0; j < c; j += 1)
			if (j % d == 0) {
				u = player_units[j].AsUnit();
				if (u.IsValid)
					if (!u.IsDiseased())
						if (!u.IsHeirOf("BaseAnimal"))
							u.Disease();
			}
	}
	while (duration > 0) {
		secs = duration % 60000 / 1000;
		if (secs < 10)
			zero_sec_marker = "0";
		else
			zero_sec_marker = "";
		ShowAnnouncement("Plague", Translatef("Player %s1 - Plague - %s2", owning_player, duration / 60000 + ":" + zero_sec_marker + secs));
		duration -= 1000;
		Sleep(1000);
	}

	HideAnnouncement("Plague");
}