//int, GAIKA gaika, int aiPlayer

Settlement set;
int nOwn, nAlly, nEnemy, enemy_hidden;

set = gaika.settlement;

gaika.Eval(AI_STAYING, aiPlayer, nOwn, nAlly, nEnemy, enemy_hidden);
if (set.IsValid)
	if (set.IsOutpost)
		nOwn += gaika.ApproachingSquads(aiPlayer, 1600);//important: approach distance value must be like in "GS_Capture.vs"!

if (nOwn > 0) {
	int nOwnC, nAllyC, nEnemyC, enemyHiddenC;
	bool bEnemyArmy, bOwnedSet = false, bEnemySet = false, bCanEnter = false, bCanBeCaptured = false;

	gaika.Count(AI_STAYING, aiPlayer, nOwnC, nAllyC, nEnemyC, enemyHiddenC);

	bEnemyArmy = nEnemy > 0;
	if (!bEnemyArmy) {
		int nOwnLv, nAllyLv, nEnemyLv, nEnemyHiddenLv;
		gaika.Count(AI_LEAVING, aiPlayer, nOwnLv, nAllyLv, nEnemyLv, nEnemyHiddenLv);
		bEnemyArmy = nEnemyLv > 0;
	}

	//settlement
	if (set.IsValid) {
		if (set.player == aiPlayer)
			bOwnedSet = true;
		else if (!DiplGetCeaseFire(set.player, aiPlayer))
			bEnemySet = true;

		if (bOwnedSet)
			bCanEnter = true;
		else if (set.NumGates <= 0)
			bCanEnter = true;

		if (set.IsTTent) {//tents always return true even when independent (outposts return false)
			if (!set.IsIndependent)
				bCanBeCaptured = set.CanBeCaptured;
		}
		else
			bCanBeCaptured = set.CanBeCaptured;
	}

	if (bOwnedSet)
		if (!set.IsFull)
			if (!set.IsTTent) {
				if (!bEnemyArmy)
					return GS_EnterSettlement;
				if (nEnemy >= nOwn * 2)
					if (!set.IsStronghold)
						return GS_EnterSettlement;
			}

	if (bEnemySet)
		if (bCanEnter)
			if (bCanBeCaptured) {
				if (!bEnemyArmy)
					if (nOwnC + nAllyC > 5)
						return GS_Capture;
				if (nOwn + nAlly > nEnemy * 2) {
					int nOwnSt, nAllySt, nEnemySt, nEnemyHiddenSt;
					gaika.Count(AI_STAYING, aiPlayer, nOwnSt, nAllySt, nEnemySt, nEnemyHiddenSt);
					if (nOwnSt + nAllySt > 10)
						return GS_Capture;
				}
				else if (nEnemy > 30000)
					if (nOwn + nAlly > nEnemy) {
						int nOwnSt, nAllySt, nEnemySt, nEnemyHiddenSt;
						gaika.Count(AI_STAYING, aiPlayer, nOwnSt, nAllySt, nEnemySt, nEnemyHiddenSt);
						if (nOwnSt + nAllySt > 10)
							return GS_Capture;
					}
				return GS_NONE;
			}

	if (bEnemyArmy) {
		if (!bEnemySet)
			return GS_KillEnemies;
		if (bCanEnter)
			return GS_KillEnemies;
	}

	if (bEnemySet)
		if (!bCanEnter) {
			if (gaika.NoAttack(aiPlayer))
				return GS_Guard;
			if (nOwnC + nAllyC >= 15)
				return GS_Siege;
			if (nOwnC + nAllyC > 5)
				if (nOwn + nAlly > nEnemy * 2)
					return GS_Siege;
			if (set.IsIndependent)
				return GS_Siege;
		}

	if (bEnemySet)
		return GS_NONE;
	if (set.IsTTent)
		return GS_NONE;

	return GS_Guard;
}

return GS_NONE;