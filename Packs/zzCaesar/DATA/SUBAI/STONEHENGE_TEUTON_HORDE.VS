//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList strongholds;
	Building b;
	Settlement set;
	Unit u;
	point pt_pos;
	int i, j, k, u_level, owning_player, d = 180;
	str announcement;

	owning_player = EnvReadInt(this, "OwningPlayer");
	pt_pos = .pos;
	announcement = "TeutonHorde_" + owning_player + "_" + pt_pos.x + "_" + pt_pos.y;

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");
	EnvWriteInt("/TeutonHordeStonehenge", 1);//used in "The conquest of Britain" adventure

	while (d > 0) {
		i = d % 60;
		if (i < 10)
			ShowAnnouncement(announcement, Translatef("Player %s1 - Teuton horde - %s2:0%s3", owning_player, d / 60, i));
		else
			ShowAnnouncement(announcement, Translatef("Player %s1 - Teuton horde - %s2:%s3", owning_player, d / 60, i));
		d -= 1;
		Sleep(1000);
	}

	d = GetConst("MinPopulation");

	for (i = 1; i <= 16; i += 1) {
		if (i == owning_player)
			u_level = 18;
		else
			u_level = 12;
		strongholds = GetSettlements("BaseTownhall", i);
		for (j = strongholds.count - 1; j >= 0; j -= 1) {
			b = strongholds[j].AsBuilding();
			pt_pos = b.pos;
			set = b.settlement;
			set.SetPopulation(MIN(set.population, d));
			for (k = 0; k < 40; k += 1) {
				u = Place("TTeutonRider", pt_pos, i).AsUnit();
				u.SetLevel(u_level);
				set.ForceAddUnit(u);
			}
			for (k = 0; k < 40; k += 1) {
				u = Place("TTeutonArcher", pt_pos, i).AsUnit();
				u.SetLevel(u_level);
				set.ForceAddUnit(u);
			}
			for (k = 0; k < 20; k += 1) {
				u = Place("TTeutonWolf", pt_pos, i).AsUnit();
				u.SetLevel(u_level);
				set.ForceAddUnit(u);
			}
		}
	}

	HideAnnouncement(announcement);
}