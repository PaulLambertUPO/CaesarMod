//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList things;
	Settlement settle;
	Wagon wagon;
	int duration, time_step, base_percent, base_additional, owning_player, interval, percent, additional, c, l, k;

	duration = GetConst("StonehengeStarvationTime");
	time_step = GetConst("StonehengeStarvationTimeStep");
	base_percent = GetConst("StonehengeStarvationPercentFood");
	base_additional = GetConst("StonehengeStarvationAdditionalFood");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	for (interval = duration / time_step; interval > 0; interval -= 1) {
		things = GetSettlements("Building", 0);
		c = things.count;
		for (l = 0; l < c; l += 1) {
			settle = things[l].AsBuilding().settlement;
			if (settle.player == owning_player) {
				percent = base_percent / 2;
				additional = base_additional / 2;
			}
			else {
				percent = base_percent;
				additional = base_additional;
			}
			settle.SetFood(MAX(0, settle.food * (100 - percent) / 100 - additional));
		}
		for (k = 1; k <= 16; k += 1) {
			if (k == owning_player) {
				percent = base_percent / 2;
				additional = base_additional / 2;
			}
			else {
				percent = base_percent;
				additional = base_additional;
			}
			things = GetPlayerUnits(k, "Wagon");
			things.ClearDead();
			c = things.count;
			for (l = 0; l < c; l += 1) {
				wagon = things[l].AsWagon();
				if (wagon.restype == 1)//0 = gold, 1 = food
					wagon.SetFood(MAX(0, wagon.amount * (100 - percent) / 100 - additional));
			}
		}
		Sleep(time_step);
	}
}