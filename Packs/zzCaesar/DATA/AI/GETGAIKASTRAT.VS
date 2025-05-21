//int, GAIKA gaika, int idPlayer

Settlement set;
bool bEnemyArmy, bOwnedSet = false, bEnemySet = false, bCanEnter = false, bCanBeCaptured = false;
int nOwn, nAlly, nEnemy, enemy_hidden, nOwnC, nAllyC, nEnemyC, enemyCHidden, nApproachDist = 1600;//important: nApproachDist value must be like in GS_Capture.vs!

set = gaika.settlement;

gaika.Eval(AI_STAYING, idPlayer, nOwn, nAlly, nEnemy, enemy_hidden);
if (set.IsValid)
	if (set.IsOutpost)
		nOwn += gaika.ApproachingSquads(idPlayer, nApproachDist);

if (nOwn <= 0)
	return GS_NONE;

gaika.Count(AI_STAYING, idPlayer, nOwnC, nAllyC, nEnemyC, enemyCHidden);

bEnemyArmy = nEnemy > 0;
if (!bEnemyArmy) {
	int nLOwn, nLAlly, nLEnemy, nLEnemyHidden;
	gaika.Count(AI_LEAVING, idPlayer, nLOwn, nLAlly, nLEnemy, nLEnemyHidden);
	bEnemyArmy = nLEnemy > 0;
}

//settlement
if (set.IsValid) {
	if (set.player == idPlayer)
		bOwnedSet = true;
	else if (!DiplGetCeaseFire(set.player, idPlayer))
		bEnemySet = true;
	if (bOwnedSet)
		bCanEnter = true;
	else if (set.NumGates <= 0)
		bCanEnter = true;
	if (!set.IsTTent)
		bCanBeCaptured = set.CanBeCaptured();//tents always return true even when independent (outposts return false)
	else if (!set.IsIndependent)
		bCanBeCaptured = set.CanBeCaptured();
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
			bool bCapture = false;
			if (!bEnemyArmy)
				if (nOwnC + nAllyC > 5)
					bCapture = true;
			if (!bCapture)
				if (nOwn + nAlly > nEnemy * 2 || nOwn + nAlly > nEnemy && nEnemy > 30000) {
					int nOwnCn, nAllyCn, nEnemyCn, nEnemyCnHidden;
					gaika.Count(AI_STAYING, idPlayer, nOwnCn, nAllyCn, nEnemyCn, nEnemyCnHidden);
					if (nOwnCn + nAllyCn > 10)
						bCapture = true;
				}
			if (bCapture)
				return GS_Capture;
			else
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
		if (gaika.NoAttack(idPlayer))
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