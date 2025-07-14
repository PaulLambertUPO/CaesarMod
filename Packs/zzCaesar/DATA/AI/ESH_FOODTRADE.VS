//void, Settlement set

int AIPlayer;
GAIKA gSellFood;
Settlement sSell;

AIPlayer = set.player;
gSellFood = GetGAIKA(EnvReadInt(set, "gSellFood"));

if (GetTime() >= EnvReadInt(AIPlayer, "FoodTradeTime"))
	gSellFood = 0;
else if (!gSellFood.settlement.IsOwn(AIPlayer))
	gSellFood = 0;
else if (!gSellFood.settlement.supplied.IsValid)
	gSellFood = 0;

if (gSellFood == 0) {//find best place to sell food
	point gCenter;
	int i, best, nMaxSetIdx, nRace, nDist, nODist, nADist, nEDist, nEval;

	gCenter = set.GetGaika().Center;
	nMaxSetIdx = MaxSetIdx();

	for (i = 0; i < nMaxSetIdx; i += 1) {
		sSell = IdxToSet(i);
		if (!sSell.IsOwn(AIPlayer))
			continue;
		if (!sSell.IsOutpost)
			continue;
		nRace = sSell.GetCentralBuilding().race;
		if (nRace != Gaul)
			if (nRace != Germany)
				continue;
		nDist = sSell.GetGaika().Center.Dist(gCenter);
		sSell.GetGaika().GetDistToPlayers(AIPlayer, nODist, nADist, nEDist);
		if (nEDist < 0)
			nEDist = 32000;
		nEval = nEDist - nDist;
		if (nEval > best) {
			gSellFood = sSell.GetGaika();
			best = nEval;
		}
	}
	if (gSellFood != 0) {//new place to sell food
		sSell = gSellFood.settlement;
		EnvWriteInt(set, "gSellFood", gSellFood.ID);
		EnvWriteInt(AIPlayer, "FoodTradeTime", GetTime() + 90000);
		sSell.StartSupplyFood(set);
	}
}

if (gSellFood != 0) {//place to sell food
	sSell = gSellFood.settlement;
	if (sSell.food < 500)
		if (GetTime() >= EnvReadInt(AIPlayer, "FoodTradeWagonWait")) {
			Wagon wagon;
			wagon = set.CreateMuleFood(MIN(1000, set.food - 1000));//do not go below 1000 food in the stronghold (to start the script, stronghold must have at least 1100 food)
			if (wagon.IsValid) {
				wagon.AddCommand(false, "unload", sSell.GetCentralBuilding());
				wagon.KillCommand();
				EnvWriteInt(AIPlayer, "FoodTradeWagonWait", GetTime() + 10000);//avoid spamming too many wagons
			}
		}
}