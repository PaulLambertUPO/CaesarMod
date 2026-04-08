//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList player_units;
	Unit u;
	str announcement;
	int i, j, d, owning_player;

	owning_player = EnvReadInt(this, "OwningPlayer");
	announcement = "Plague_" + owning_player + "_" + .pos.x + "_" + .pos.y;

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	for (i = 1; i <= 16; i += 1) {
		if (i == owning_player)
			d = 8;
		else
			d = 7;
		player_units = GetPlayerUnits(i);//there would be too much overhead to check the real player of every unit for the divider to work correctly (GetPlayerUnits takes units from other players that are attached to player i's heroes)
		for (j = player_units.count - 1; j >= 0; j -= 1)
			if (j % d == 0) {
				u = player_units[j].AsUnit();
				if (u.IsAlive)
					if (!u.IsDiseased)
						if (!u.IsHeirOf("BaseAnimal"))
							u.Disease();
			}
	}

	d = 60;
	while (d > 0) {
		i = d % 60;
		if (i < 10)
			ShowAnnouncement(announcement, Translatef("Player %s1 - Plague - %s2:0%s3", owning_player, d / 60, i));
		else
			ShowAnnouncement(announcement, Translatef("Player %s1 - Plague - %s2:%s3", owning_player, d / 60, i));
		d -= 1;
		Sleep(1000);
	}

	HideAnnouncement(announcement);
}