//int, Squad sq, GAIKA g, GAIKA *gDepend

GAIKA gCurDest;
Unit sqLeader;
Obj teleport;
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
						return 0;
}

gCurDest = sq.AIDest;
if (gCurDest == g)
	return 0;

//do not give tasks too often
nStateTime = sq.StateTime;
if (GetTime() < 180000)
	nStateTime = 10000000;
if (!bAssUnderFire)
	if (nStateTime < 1000 * AIVar(idPlayer, AIV_SquadRecruitWait))
		return 0;

sqLeader = sq.Leader;
if (sqLeader.AsShip().IsValid()) {
	if (sqLeader.AsShip().HasAiTransport())
		return 0;
	if (!IsWaterLsa(g.LSA))
		return 0;
}
else if (IsWaterLsa(g.LSA))
	return 0;

if (AIVar(idPlayer, AIV_UseTeleports) != 0)
	teleport = FindTeleport(idPlayer, sq.pos, g.Center);
if (teleport.IsValid)
	lsaPathLen = 1;
else
	lsaPathLen = CheckLsaPath(sq.GAIKAIn.LSA, g.LSA, idPlayer);
if (lsaPathLen == 0)
	return 0;

//defensive AI addition - do not attack GAIKAs that are not marked for an attack
if (!g.GetControlFlag(idPlayer))
	if (GetTime() > 300000)
		if (g.Explored(idPlayer))
			return 0;
		else if (sq.Size > 5)
			return 0;

if (!bAssUnderFire) {
	Settlement set, s;
	bool bFightForFood = false;

	set = g.settlement;

	//do not explore with Trident Warriors, Viking Lords or Elephants
	if (sqLeader.HasFreedom()) {
		if (sqLeader.IsHeirOf("GTridentWarrior") || sqLeader.IsHeirOf("BVikingLord") || sqLeader.IsHeirOf("CWarElephant"))
			if (g.Eval(AI_STAYING, idPlayer, AI_ENEMY) < 500)
				return 0;
		if (set.IsIndependent)
			if (set.IsStronghold)
				return 0;
		if (!g.Explored(idPlayer))
			return 0;
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
					return 0;
			}
			if (!set.IsOwn(idPlayer) || !set.IsStronghold)
				if (sq.health < sq.maxhealth * 4 / 5)
					if (s.IsValid)
						if (s.food > 100)
							return 0;//heal first
		}
		else {
			if (sq.Units.count < 10)
				if (sqLeader.GetHolderSett().IsTTent)
					return 0;
			if (g.Explored(idPlayer))
				if (!set.IsIndependent)
					if (s.IsStronghold)
						if (!sq.HasFreedom())
							if (s.IsOwn(idPlayer))
								return 0;//wait to attach before sending
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