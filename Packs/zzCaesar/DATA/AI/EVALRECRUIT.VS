//int, Squad sq, GAIKA g, GAIKA *gDepend

GAIKA gCurDest;
Unit sqLeader;
Obj teleport;
Settlement set;
int idPlayer, nStateTime, lsaPathLen, nEval;
bool bAssUnderFire;

idPlayer = sq.Player;
bAssUnderFire = g.ID == EnvReadInt(idPlayer, "AssUnderFireGaika");

if (!bAssUnderFire) {
	int nSqState;
	nSqState = sq.State;
	if (nSqState != SS_IDLE)
		if (nSqState != SS_Approach)
			if (nSqState != SS_Wait)
				if (nSqState != SS_ApproachWait)
					if (nSqState != SS_Enter)
						return -1;
}

gCurDest = sq.AIDest;
if (gCurDest == g)
	return -2;

//do not give tasks too often
nStateTime = sq.StateTime;
if (GetTime() < 180000)
	nStateTime = 10000000;
if (!bAssUnderFire)
	if (nStateTime < 1000 * AIVar(idPlayer, AIV_SquadRecruitWait))
		return -3;

sqLeader = sq.Leader;
if (sqLeader.AsShip().IsValid) {
	if (sqLeader.AsShip().HasAiTransport)
		return -4;
	if (!IsWaterLsa(g.LSA))
		return -5;
}
else if (IsWaterLsa(g.LSA))
	return -6;

if (AIVar(idPlayer, AIV_UseTeleports) != 0)
	teleport = FindTeleport(idPlayer, sq.pos, g.Center);
if (teleport.IsValid)
	lsaPathLen = 1;
else
	lsaPathLen = CheckLsaPath(sq.GAIKAIn.LSA, g.LSA, idPlayer);
if (lsaPathLen == 0)
	return -7;

//prevent scattering small armies
if (set.IsValid)
	if (!set.IsOwn(idPlayer))
		if (set.IsTTent || !set.IsIndependent || set.IsIndependentGuarded)
			if (!sqLeader.AsHero().IsValid)
				if (!sqLeader.HasFreedom())
					return -8;

if (!bAssUnderFire) {
	Settlement s;
	bool bFightForFood = false;

	//do not explore with Trident Warriors, Viking Lords or Elephants
	if (sqLeader.HasFreedom()) {
		if (sqLeader.IsHeirOf("GTridentWarrior") || sqLeader.IsHeirOf("BVikingLord") || sqLeader.IsHeirOf("CWarElephant"))
			if (g.Eval(AI_STAYING, idPlayer, AI_ENEMY) < 500)
				return -9;
		if (set.IsIndependent)
			if (set.IsStronghold)
				return -10;
		if (!g.Explored(idPlayer))
			return -11;
	}

	s = sq.GAIKAIn.settlement;

	if (set.IsVillage)
		if (s.IsStronghold)
			if (s.food < 100)
				bFightForFood = true;

	if (!bFightForFood)
		if (sqLeader.AsHero().IsValid) {
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
					return -12;
			}
			if (!set.IsOwn(idPlayer) || !set.IsStronghold)
				if (sq.health < sq.maxhealth * 4 / 5)
					if (s.IsValid)
						if (s.food > 100)
							return -13;//heal first
		}
		else {
			if (sq.Units.count < 10)
				if (sqLeader.GetHolderSett().IsTTent)
					return -14;
			if (g.Explored(idPlayer))
				if (!set.IsIndependent)
					if (s.IsStronghold)
						if (!sq.HasFreedom())
							if (s.IsOwn(idPlayer))
								return -15;//wait to attach before sending
		}

	if (gCurDest.GetPriority(idPlayer) >= g.GetPriority(idPlayer))
		gDepend = gCurDest;//remember that gDepend is a reference variable, it is not used directly here but it is important not to remove it
}

nEval = 100000 - sq.pos.Dist(g.Center) * lsaPathLen;

//do not give tasks too often
{
	int nWeightTime;
	nWeightTime = AIVar(idPlayer, AIV_SquadRecruitWeight);
	if (nWeightTime > 0) {
		nStateTime = nStateTime / 1000;
		if (nStateTime < nWeightTime)
			nEval = MAX(1, nEval * nStateTime / nWeightTime);
	}
}

return nEval;