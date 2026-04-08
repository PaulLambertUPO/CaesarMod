//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList settlements;
	Settlement set;
	str announcement;
	int i, owning_player, duration = 120;

	owning_player = EnvReadInt(this, "OwningPlayer");
	announcement = "GoldRain_" + owning_player + "_" + .pos.x + "_" + .pos.y;

	settlements.AddList(GetSettlements("BaseTownhall", 0));
	settlements.AddList(GetSettlements("BaseVillage", 0));
	settlements.AddList(GetSettlements("BaseShipyard", 0));
	settlements.AddList(GetSettlements("Outpost", 0));

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");
	EnvWriteInt("/GoldRainStonehenge", 1);//used in "The conquest of Britain" adventure

	while (duration > 0) {
		i = duration % 60;
		if (i < 10)
			ShowAnnouncement(announcement, Translatef("Player %s1 - Gold rain - %s2:0%s3", owning_player, duration / 60, i));
		else
			ShowAnnouncement(announcement, Translatef("Player %s1 - Gold rain - %s2:%s3", owning_player, duration / 60, i));

		if (duration % 3 == 0)
			for (i = settlements.count - 1; i >= 0; i -= 1) {
				set = settlements[i].AsBuilding().settlement;
				if (set.player == owning_player) {
					set.SetGold(set.gold + 15);
					set.GoldConverted(15);
				}
				else {
					set.SetGold(set.gold + 10);
					set.GoldConverted(10);
				}
			}

		duration -= 1;
		Sleep(1000);
	}

	HideAnnouncement(announcement);
}