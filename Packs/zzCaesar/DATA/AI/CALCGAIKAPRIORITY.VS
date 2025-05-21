//int, int idPlayer, GAIKA g

int nPriority, nHomeDist, nAllyHomeDist, nEnemyHomeDist, nMaxDist, nActualPerc;
Settlement set;
rect rcMap;

set = g.settlement;

rcMap = GetMapRect();
nMaxDist = Point(rcMap.left, rcMap.top).Dist(Point(rcMap.right, rcMap.bottom));
g.GetDistToPlayers(idPlayer, nHomeDist, nAllyHomeDist, nEnemyHomeDist);

nActualPerc = 30;
if (AIVar(idPlayer, AIV_LuckyExplore) == 0 && !g.Explored(idPlayer))
	nActualPerc = 70;
else if (set.IsStronghold())
	nActualPerc = 100;
else if (set.IsVillage())
	nActualPerc = 90;
else if (set.IsTTent())
	nActualPerc = 80;
else if (set.IsOutpost()) {
	nActualPerc = 60;
	if (set.IsIndependent)
		nActualPerc = 80;
	if (AIVar(idPlayer, AIV_TradeGold) > 0) {
		int nRace;
		nRace = set.GetCentralBuilding().race;
		if (nRace == RepublicanRome)
			nActualPerc += 10;
		else if (nRace == Egypt)
			nActualPerc += 10;
	}
}
else if (set.IsShipyard)
	nActualPerc = 60;

nPriority = nActualPerc * (MaxGAIKAPriority * (100 - nHomeDist * 100 / nMaxDist) / 100) / 100;

return MAX(1, MIN(nPriority, MaxGAIKAPriority - 1));//it must be higher than 0