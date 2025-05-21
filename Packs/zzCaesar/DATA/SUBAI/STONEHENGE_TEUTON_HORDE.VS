//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList townhalls;
	Building b;
	Settlement settle;
	Unit u;
	int duration, base_level, caster_level, t_riders, t_archers, t_wolves, min_pop, owning_player, secs, level, i, j, k, c;
	str zero_sec_marker;

	duration = GetConst("StonehengeTeutonHordeTime");
	base_level = GetConst("StonehengeTeutonHordeBaseLevel");
	caster_level = GetConst("StonehengeTeutonHordeCasterLevel");
	t_riders = GetConst("StonehengeTeutonHordeRiders");
	t_archers = GetConst("StonehengeTeutonHordeArchers");
	t_wolves = GetConst("StonehengeTeutonHordeWolves");
	min_pop = GetConst("MinPopulation");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");
	EnvWriteInt("/TeutonHordeStonehenge", 1);//used in "The conquest of Britain" adventure

	while (duration > 0) {
		secs = duration % 60000 / 1000;
		if (secs < 10)
			zero_sec_marker = "0";
		else
			zero_sec_marker = "";
		ShowAnnouncement("TeutonHorde", Translatef("Player %s1 - Teuton horde - %s2", owning_player, duration / 60000 + ":" + zero_sec_marker + secs));
		duration -= 1000;
		Sleep(1000);
	}

	for (i = 1; i <= 16; i += 1) {
		if (i == owning_player)
			level = caster_level;
		else
			level = base_level;
		townhalls = ClassPlayerObjs("BaseTownhall", i).GetObjList();
		c = townhalls.count;
		for (j = 0; j < c; j += 1) {
			b = townhalls[j].AsBuilding();
			settle = b.settlement;
			settle.SetPopulation(MIN(settle.population, min_pop));
			for (k = 0; k < t_riders; k += 1) {
				u = Place("TTeutonRider", b.pos, i);
				u.SetLevel(level);
				u.SetFood(u.maxfood);
				settle.ForceAddUnit(u);
			}
			for (k = 0; k < t_archers; k += 1) {
				u = Place("TTeutonArcher", b.pos, i);
				u.SetLevel(level);
				u.SetFood(u.maxfood);
				settle.ForceAddUnit(u);
			}
			for (k = 0; k < t_wolves; k += 1) {
				u = Place("TTeutonWolf", b.pos, i);
				u.SetLevel(level);
				u.SetFood(u.maxfood);
				settle.ForceAddUnit(u);
			}
		}
	}

	HideAnnouncement("TeutonHorde");
}