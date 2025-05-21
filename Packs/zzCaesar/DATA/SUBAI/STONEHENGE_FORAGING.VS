//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList player_units;
	Unit u;
	int duration, time_step, base_food, caster_food, owning_player, secs, food_increase, i, j, c;
	str zero_sec_marker;

	duration = GetConst("StonehengeForagingTime");
	time_step = GetConst("StonehengeForagingTimeStep");
	base_food = GetConst("StonehengeForagingBaseAmount");
	caster_food = GetConst("StonehengeForagingCasterAmount");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	while (duration > 0) {
		secs = duration % 60000 / 1000;
		if (secs < 10)
			zero_sec_marker = "0";
		else
			zero_sec_marker = "";
		ShowAnnouncement("Foraging", Translatef("Player %s1 - Foraging - %s2", owning_player, duration / 60000 + ":" + zero_sec_marker + secs));

		if (duration % time_step == 0)
			for (i = 1; i <= 16; i += 1) {
				player_units = GetPlayerUnits(i);
				player_units.ClearDead();
				c = player_units.count;
				for (j = 0; j < c; j += 1) {
					u = player_units[j].AsUnit();
					if (u.IsValid)
						if (u.food <= u.maxfood) {
							if (u.player == owning_player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								food_increase = caster_food;
							else
								food_increase = base_food;
							u.SetFood(MIN(u.food + food_increase, u.maxfood));
						}
				}
			}

		duration -= 1000;
		Sleep(1000);
	}

	HideAnnouncement("Foraging");
}