//void, Settlement set

int AIPlayer, timeLimit;

AIPlayer = set.player;
timeLimit = EnvReadInt(AIPlayer, "GoldTradeTime");

if (GetTime() >= timeLimit)
	if (EnvReadInt(AIPlayer, "GoldTradeStartInProgress") != 1) {
		GAIKA gSell;
		Settlement sSell;
		point gCenter;
		int i, best, nRace, nDist, nODist, nADist, nEDist, nEval;

		gCenter = set.GetGaika().Center;

		for (i = 0; i < MaxSetIdx; i += 1) {
			sSell = IdxToSet(i);
			if (!sSell.IsOwn(AIPlayer))
				continue;
			if (!sSell.IsOutpost)
				continue;
			nRace = sSell.GetCentralBuilding().race;
			if (nRace != RepublicanRome)
				if (nRace != Egypt)
					continue;
			if (sSell.supplied.IsValid)
				continue;
			nDist = sSell.GetGaika().Center.Dist(gCenter);
			sSell.GetGaika().GetDistToPlayers(AIPlayer, nODist, nADist, nEDist);
			if (nEDist < 0)
				nEDist = 32000;
			nEval = nEDist - nDist;
			if (nEval > best) {
				gSell = sSell.GetGaika();
				best = nEval;
			}
		}
		if (gSell != 0) {//new place to sell gold
			sSell = gSell.settlement;
			sSell.RunEconomyScript(ES_OutpostSellGold);
			EnvWriteInt(AIPlayer, "GoldTradeTime", timeLimit + 300000 + rand(3) * 60000);
		}
	}