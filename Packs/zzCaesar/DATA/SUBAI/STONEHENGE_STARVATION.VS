//void, Obj This

Building this;
ObjList settlements, player_wagons;
Settlement set;
Wagon wagon;
int i, j, k, caster_player, percent, additional;

this = This.AsBuilding();

caster_player = EnvReadInt(this, "CasterPlayer");

.GlobalSpellStart(gsStarvation, caster_player);

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

settlements.AddList(GetSettlements("BaseTownhall", 0));
settlements.AddList(GetSettlements("BaseVillage", 0));
settlements.AddList(GetSettlements("BaseShipyard", 0));
settlements.AddList(GetSettlements("Outpost", 0));
settlements.AddList(GetSettlements("TTent", 0));

for (i = GetConst("StonehengeStarvationTime") / 5000; i > 0; i -= 1) {
	for (j = settlements.count - 1; j >= 0; j -= 1) {
		set = settlements[j].AsBuilding().settlement;
		if (set.player == caster_player)
			set.SetFood(MAX(0, set.food * 99 / 100 - 10));
		else
			set.SetFood(MAX(0, set.food * 98 / 100 - 20));
	}
	for (j = 1; j <= 16; j += 1) {
		if (j == caster_player) {
			percent = 99;
			additional = 10;
		}
		else {
			percent = 98;
			additional = 20;
		}
		player_wagons = GetPlayerUnits(j, "Wagon");
		for (k = player_wagons.count - 1; k >= 0; k -= 1) {
			wagon = player_wagons[k].AsWagon();
			if (wagon.IsAlive)
				if (wagon.restype == 1)
					wagon.SetFood(MAX(0, wagon.amount * percent / 100 - additional));
		}
	}
	Sleep(5000);
}