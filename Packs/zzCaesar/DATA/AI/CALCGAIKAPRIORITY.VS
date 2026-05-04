//int, int aiPlayer, GAIKA g

Settlement set;
int nHomeDist, nAllyHomeDist, nEnemyHomeDist, nActualPerc = 30;
rect rcMap;

g.GetDistToPlayers(aiPlayer, nHomeDist, nAllyHomeDist, nEnemyHomeDist);

set = g.settlement;

if (set.IsValid) {
	bool explored = false;

	if (AIVar(aiPlayer, AIV_LuckyExplore) == 0)
		if (g.Explored(aiPlayer))
			explored = true;

	if (!explored)
		nActualPerc = 70;
	else if (set.IsStronghold)
		nActualPerc = 100;
	else if (set.IsVillage) {
		nActualPerc = 90;
		if (set.IsIndependent)
			nActualPerc += 10;
	}
	else if (set.IsTTent) {
		nActualPerc = 80;
		if (set.IsIndependent)
			nActualPerc += 15;
	}
	else if (set.IsOutpost) {
		nActualPerc = 60;
		if (set.IsIndependent)
			nActualPerc += 25;
		if (AIVar(aiPlayer, AIV_TradeGold) > 0) {
			int nRace;
			nRace = set.GetCentralBuilding().race;
			if (nRace == RepublicanRome)
				nActualPerc += 10;
			else if (nRace == Egypt)
				nActualPerc += 10;
		}
	}
	else if (set.IsShipyard) {
		nActualPerc = 60;
		if (set.IsIndependent)
			nActualPerc += 20;
	}
}

rcMap = GetMapRect();

return MAX(
	1,
	MIN(
		MaxGAIKAPriority - 1,
		nActualPerc * (MaxGAIKAPriority * (100 - nHomeDist * 100 / Dist(Point(rcMap.left, rcMap.top), Point(rcMap.right, rcMap.bottom))) / 100) / 100
	)
);//it must be greater than 0