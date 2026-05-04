//int, GAIKA g, int aiPlayer, bool bMin, int own, int ally, int enemy

Settlement set;
int nEval, time, enemySt;
bool bValidSet, bEnemySet = false, bIsStronghold = false, bCap = true;

set = g.settlement;
bValidSet = set.IsValid;

if (bValidSet) {
	if (set.IsEnemy(aiPlayer))
		bEnemySet = true;
	if (set.IsStronghold)
		bIsStronghold = true;
	if (!bIsStronghold)
		if (set.IsIndependent)
			if (!set.IsIndependentGuarded)
				if (!set.IsTTent)
					return 1;
}

time = GetTime();

if (!g.Explored(aiPlayer)) {
	if (!bValidSet)
		return 1;
	if (!set.IsTTent)
		return 1;
	if (time > 600000)
		return 1;
}

if (!g.Revealed(aiPlayer))
	if (!bIsStronghold)
		if (time - g.LastSeen(aiPlayer) >= 600000)
			enemy = 1;//expect few enemies if non-stronghold GAIKA not visited for 10 minutes

if (enemy > 0) {//add enemies from adjacent revealed GAIKAs
	int ownSt, allySt;
	g.EvalNeighbors(AI_STAYING, aiPlayer, ownSt, allySt, enemySt, true);//true = revealed gaikas only
	if (enemySt > ownSt)
		enemy += (enemySt - ownSt) * 2 / 3;
}

if (bValidSet)
	if (set.IsOwn(aiPlayer)) {
		if (enemy <= 0) {//protect unattacked settlements
			if (set.IsOutpost)
				if (set.supplied.IsValid) {//trade and gold outposts need protection
					if (set.gold >= 1000)
						if (bMin)
							return 4000;
						else
							return 8000;
					if (set.food >= 500)
						if (bMin)
							return 6000;
						else
							return 10000;
				}
			return 0;
		}
		if (enemy >= 500)
			bCap = false;//no minimum when defending owned settlements
	}
	else if (bIsStronghold) {
		if (set.IsIndependent)
			return 1500;
		if (bEnemySet) {
			if (bMin)
				nEval = 5001;
			else
				nEval = 15001;
			enemy += enemySt / 2;
		}
	}
	else if (set.IsVillage) {
		if (set.IsIndependent) {
			if (enemy <= 0)
				return 1;
		}
		else if (bEnemySet) {
			Settlement s;
			s = NearestStronghold(set.GetCentralBuilding().pos, aiPlayer);
			if (s.IsValid)
				if (s.food <= 100)
					bCap = false;//no minimum for enemy villages if starving
			nEval = 1;
		}
	}
	else if (set.IsOutpost) {
		if (set.IsIndependent) {
			if (enemy <= 0)
				return 1;
		}
		else if (bEnemySet)
			nEval = 1;
	}
	else if (set.IsShipyard) {
		if (set.IsIndependent) {
			if (enemy <= 0)
				return 1;
		}
		else if (bEnemySet)
			nEval = 1;
	}
	else if (enemy <= 0)
		return 0;

if (bMin)
	if (time < 900000)
		nEval += enemy * 3 / 2;
	else
		nEval += enemy * 11 / 10;
else
	nEval += enemy * 4;

if (bEnemySet || nEval > 0) {
	int min;

	if (bCap)
		if (time < 600000)
			min = 4000;
		else if (time < 120000)
			min = 6000;
		else if (time < 180000)
			min = 10000;
		else
			min = 12000;
	else if (bIsStronghold)
		if (bEnemySet)
			min = 6000;

	if (bMin)
		min = min / 2;

	if (nEval < min)
		nEval = min;
}

return nEval;