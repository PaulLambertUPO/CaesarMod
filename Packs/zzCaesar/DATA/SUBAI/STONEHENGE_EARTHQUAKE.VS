//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList buildings;
	Building b;
	int duration, time_step, base_damage, owning_player, secs, damage_to_take, i, j, c;
	str zero_sec_marker;

	duration = GetConst("StonehengeEarthquakeTime");
	time_step = GetConst("StonehengeEarthquakeTimeStep");
	base_damage = GetConst("StonehengeEarthquakeDamage");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	while (duration > 0) {
		secs = duration % 60000 / 1000;
		if (secs < 10)
			zero_sec_marker = "0";
		else
			zero_sec_marker = "";
		ShowAnnouncement("Earthquake", Translatef("Player %s1 - Earthquake - %s2", owning_player, duration / 60000 + ":" + zero_sec_marker + secs));

		if (duration % time_step == 0)
			for (i = 1; i <= 16; i += 1) {
				if (i == owning_player)
					damage_to_take = base_damage * 3 / 4;
				else
					damage_to_take = base_damage;
				buildings = Union(Union(ClassPlayerObjs("Wall", i), ClassPlayerObjs("Gate", i)), Union(ClassPlayerObjs("Tower", i), ClassPlayerObjs("BaseTownBuilding", i))).GetObjList();
				c = buildings.count;
				for (j = 0; j < c; j += 1) {
					b = buildings[j].AsBuilding();
					if (b.health > 0)
						b.Damage(damage_to_take);
				}
			}

		duration -= 1000;
		Sleep(1000);
	}

	HideAnnouncement("Earthquake");
}