//int, Squad sq, GAIKA g, GAIKA *gDepend

GAIKA gCurDest;
Unit sqLeader;
Settlement set;
int aiPlayer, lsaPathLen, nEval;
bool bAssUnderFire;

aiPlayer = sq.Player;
bAssUnderFire = g.ID == EnvReadInt(aiPlayer, "AssUnderFireGaika");

if (!bAssUnderFire) {
	int sqState;
	sqState = sq.State;
	if (sqState != SS_IDLE)
		if (sqState != SS_Approach)
			if (sqState != SS_Wait)
				if (sqState != SS_ApproachWait)
					if (sqState != SS_Enter)
						return -1;
}

gCurDest = sq.AIDest;
if (gCurDest == g)
	return -2;

sqLeader = sq.Leader;
if (sqLeader.AsShip().IsValid) {
	if (sqLeader.AsShip().HasAiTransport)
		return -3;
	if (!IsWaterLsa(g.LSA))
		return -4;
}
else if (IsWaterLsa(g.LSA))
	return -5;

if (AIVar(aiPlayer, AIV_UseTeleports) == 0) {
	lsaPathLen = CheckLsaPath(sq.GAIKAIn.LSA, g.LSA, aiPlayer);
	if (lsaPathLen == 0)
		return -6;
}
else if (FindTeleport(aiPlayer, sq.pos, g.Center).IsValid)
	lsaPathLen = 1;
else {
	lsaPathLen = CheckLsaPath(sq.GAIKAIn.LSA, g.LSA, aiPlayer);
	if (lsaPathLen == 0)
		return -7;
}

set = g.settlement;

//prevent scattering small armies
if (set.IsValid)
	if (!set.IsOwn(aiPlayer))
		if (!sqLeader.AsHero().IsValid)
			if (!sqLeader.HasFreedom) {
				if (set.IsTTent)
					return -8;
				if (!set.IsIndependent)
					return -9;
				if (set.IsIndependentGuarded)
					return -10;
			}

if (!bAssUnderFire) {
	Settlement s;
	bool bFightForFood = false;

	//do not explore with Trident Warriors, Viking Lords or Elephants
	if (sqLeader.HasFreedom) {
		if (sqLeader.IsHeirOf("GTridentWarrior")) {
			if (g.Eval(AI_STAYING, aiPlayer, AI_ENEMY) < 500)
				return -11;
		}
		else if (sqLeader.IsHeirOf("BVikingLord")) {
			if (g.Eval(AI_STAYING, aiPlayer, AI_ENEMY) < 500)
				return -12;
		}
		else if (sqLeader.IsHeirOf("CWarElephant"))
			if (g.Eval(AI_STAYING, aiPlayer, AI_ENEMY) < 500)
				return -13;
		if (set.IsValid)
			if (set.IsIndependent)
				if (set.IsStronghold)
					return -14;
		if (!g.Explored(aiPlayer))
			return -15;
	}

	s = sq.GAIKAIn.settlement;

	if (set.IsValid)
		if (set.IsVillage)
			if (s.IsValid)
				if (s.IsStronghold)
					if (s.food < 100)
						bFightForFood = true;

	if (!bFightForFood)
		if (sqLeader.AsHero().IsValid) {
			if (s.IsValid) {
				if (s.IsStronghold) {
					int time, min;
					time = GetTime() / 60000;
					if (time < 10)
						min = 15;
					else if (time < 20)
						min = 20;
					else if (time < 30)
						min = 31;
					else
						min = 41;
					if (sq.Size < min)
						return -16;
				}
				if (s.food >= 100)
					if (set.IsValid)
						if (!set.IsOwn(aiPlayer)) {
							if (sq.health < sq.maxhealth * 4 / 5)
								return -17;//heal first
						}
						else if (!set.IsStronghold)
							if (sq.health < sq.maxhealth * 4 / 5)
								return -18;//heal first
			}
		}
		else {
			if (sq.Units.count < 10) {
				Settlement hs;
				hs = sqLeader.GetHolderSett();
				if (hs.IsValid)
					if (hs.IsTTent)
						return -19;
			}
			if (g.Explored(aiPlayer))
				if (set.IsValid)
					if (!set.IsIndependent)
						if (s.IsValid)
							if (s.IsStronghold)
								if (s.IsOwn(aiPlayer))
									if (!sq.HasFreedom)
										return -20;//wait to attach before sending
		}

	if (gCurDest.GetPriority(aiPlayer) >= g.GetPriority(aiPlayer))
		gDepend = gCurDest;//remember that gDepend is a reference variable, it is not used directly here but it is important not to remove it
}

nEval = 100000 - sq.pos.Dist(g.Center) * lsaPathLen;

//do not give tasks too often
{
	int nWeightTime;
	nWeightTime = AIVar(aiPlayer, AIV_SquadRecruitWeight);
	if (nWeightTime > 0) {
		int nStateTime;
		nStateTime = sq.StateTime / 1000;
		if (nStateTime < nWeightTime)
			nEval = MAX(1, nEval * nStateTime / nWeightTime);
	}
}

return nEval;