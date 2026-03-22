//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList player_units;
	Unit u;
	int i, j, owning_player, duration = 45;
	str announcement;

	owning_player = EnvReadInt(this, "OwningPlayer");
	announcement = "Foraging_" + owning_player + "_" + .pos.x + "_" + .pos.y;

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	while (duration > 0) {
		i = duration % 60;
		if (i < 10)
			ShowAnnouncement(announcement, Translatef("Player %s1 - Foraging - %s2:0%s3", owning_player, duration / 60, i));
		else
			ShowAnnouncement(announcement, Translatef("Player %s1 - Foraging - %s2:%s3", owning_player, duration / 60, i));

		if (duration % 15 == 0)
			for (i = 1; i <= 16; i += 1) {
				player_units = GetPlayerUnits(i);
				for (j = player_units.count - 1; j >= 0; j -= 1) {
					u = player_units[j].AsUnit();
					if (u.IsAlive)
						if (u.food <= u.maxfood)
							if (u.player == owning_player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								u.SetFood(MIN(u.food + 3, u.maxfood));
							else
								u.SetFood(MIN(u.food + 2, u.maxfood));
				}
			}

		duration -= 1;
		Sleep(1000);
	}

	HideAnnouncement(announcement);
}