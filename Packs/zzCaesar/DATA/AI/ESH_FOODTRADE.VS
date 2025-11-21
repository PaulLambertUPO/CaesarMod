//void, Settlement set

//called by ES_Stronghold, this script finds the best trade outpost and makes sure food is sent there in order to earn gold

int aiPlayer;
GAIKA gSellFood;
Settlement sSell;

aiPlayer = set.player;

gSellFood = GetGAIKA(EnvReadInt(set, "gSellFood"));
sSell = gSellFood.settlement;
if (!sSell.IsValid)
	gSellFood = 0;
else if (!sSell.IsOwn(aiPlayer))
	gSellFood = 0;
else if (!sSell.supplied.IsValid)
	gSellFood = 0;

if (gSellFood == 0) {//find best place to sell food
	GAIKA g;
	Building b;
	int nMaxSetIdx, nLsa, nRace, nOwnDist, nAllyDist, nEnemyDist, nEval, best, i;
	point gCenter;

	nMaxSetIdx = MaxSetIdx;
	nLsa = set.GetCentralBuilding().LSA;//using LandLsa does not work (it is for shipyards)
	gCenter = set.GetGaika().Center;

	for (i = 0; i < nMaxSetIdx; i += 1) {
		sSell = IdxToSet(i);
		if (sSell.IsOwn(aiPlayer))
			if (sSell.IsOutpost) {
				b = sSell.GetCentralBuilding();
				if (b.LSA == nLsa) {
					nRace = b.race;
					if (nRace != Gaul)
						if (nRace != Germany)
							continue;
					if (!sSell.supplied.IsValid) {
						g = sSell.GetGaika();
						g.GetDistToPlayers(aiPlayer, nOwnDist, nAllyDist, nEnemyDist);
						if (nEnemyDist < 0)
							nEnemyDist = 32000;
						nEval = nEnemyDist - g.Center.Dist(gCenter);
						if (nEval > best) {
							gSellFood = g;
							best = nEval;
						}
					}
				}
			}
	}
	if (gSellFood != 0) {//new place to sell food
		sSell = gSellFood.settlement;
		EnvWriteInt(set, "gSellFood", gSellFood.ID);
		sSell.StartSupplyFood(set);
	}
}

if (gSellFood != 0) {//place to sell food
	sSell = gSellFood.settlement;
	if (sSell.food < 500) {
		Wagon mule;
		mule = set.CreateMuleFood(MIN(1000, set.food - 1000));//do not go below 1000 food in the stronghold (to start the script, there must be at least 1100 food)
		if (mule.IsValid) {
			mule.SetCommand("unload", sSell.GetCentralBuilding());
			EnvWriteInt(set, "FoodTradeMuleWait", GetTime() + 20000);//avoid sending too many mules (the road to the outpost can be quite long)
		}
	}
}