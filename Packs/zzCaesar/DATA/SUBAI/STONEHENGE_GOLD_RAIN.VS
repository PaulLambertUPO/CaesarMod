//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList settlements;
	Settlement settle;
	int duration, time_step, base_gold_amount, caster_gold_amount, owning_player, secs, gold_increase, i, c;
	str zero_sec_marker;

	duration = GetConst("StonehengeGoldRainTime");
	time_step = GetConst("StonehengeGoldRainTimeStep");
	base_gold_amount = GetConst("StonehengeGoldRainBaseAmount");
	caster_gold_amount = GetConst("StonehengeGoldRainCasterAmount");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");
	EnvWriteInt("/GoldRainStonehenge", 1);//used in "The conquest of Britain" adventure

	while (duration > 0) {
		secs = duration % 60000 / 1000;
		if (secs < 10)
			zero_sec_marker = "0";
		else
			zero_sec_marker = "";
		ShowAnnouncement("GoldRain", Translatef("Player %s1 - Gold rain - %s2", owning_player, duration / 60000 + ":" + zero_sec_marker + secs));

		if (duration % time_step == 0) {
			settlements = GetSettlements("Building", 0);
			c = settlements.count;
			for (i = 0; i < c; i += 1) {
				settle = settlements[i].AsBuilding().settlement;
				if (settle.player == owning_player)
					gold_increase = caster_gold_amount;
				else
					gold_increase = base_gold_amount;
				settle.SetGold(settle.gold + gold_increase);
				settle.GoldConverted(gold_increase);
			}
		}

		duration -= 1000;
		Sleep(1000);
	}

	HideAnnouncement("GoldRain");
}