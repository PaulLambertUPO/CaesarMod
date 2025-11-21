//void, Settlement set

//called by ES_Stronghold, this script finds the best gold outpost and makes sure gold is sent there in order to earn even more (with ES_OutpostSellGold)

int aiPlayer, goldTradeTime;

aiPlayer = set.player;
goldTradeTime = EnvReadInt(aiPlayer, "GoldTradeTime");

if (GetTime() >= goldTradeTime) {
	GAIKA gSellGold, g;
	Settlement sSell;
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
					if (nRace != RepublicanRome)
						if (nRace != Egypt)
							continue;
					if (!sSell.supplied.IsValid) {
						g = sSell.GetGaika();
						g.GetDistToPlayers(aiPlayer, nOwnDist, nAllyDist, nEnemyDist);
						if (nEnemyDist < 0)
							nEnemyDist = 32000;
						nEval = nEnemyDist - g.Center.Dist(gCenter);
						if (nEval > best) {
							gSellGold = g;
							best = nEval;
						}
					}
				}
			}
	}

	if (gSellGold != 0) {//new place to "sell" gold
		gSellGold.settlement.RunEconomyScript(ES_OutpostSellGold);
		EnvWriteInt(aiPlayer, "GoldTradeTime", goldTradeTime + 300000 + rand(3) * 60000);
	}
}