//void, GAIKA gaika

Settlement set;
Building hall;
int AIPlayer, gtStart, nApproachDist = 1600;//important: nApproachDist value must be like in GetGAIKAStrat.vs!
bool bIsStronghold, bIsOutpost;

set = gaika.settlement;
hall = set.GetCentralBuilding();
AIPlayer = AIGetPlayer();
gtStart = GetTime();
bIsStronghold = set.IsStronghold;
bIsOutpost = set.IsOutpost;

//step 1: gather approaching army
while (set.IsEnemy(AIPlayer) && gaika.GetStrat(AIPlayer) == GS_Capture) {
	int own, ally, enemy, enemy_hidden, ownC, allyC, enemyC, enemyCHidden;
	bool bWait = false;

	//evaluate the gaika army: do not wait the rest of army if the current one is enough
	gaika.Count(AI_STAYING, AIPlayer, ownC, allyC, enemyC, enemyCHidden);
	enemyC -= enemyCHidden;
	if (bIsStronghold)
		enemyC -= set.GetNumSentries();
	if (bIsOutpost)
		enemyC += gaika.Count(AI_ENEMY, AIPlayer, "Peasant");//count peasants because they contribute to the attack rate of outpost towers
	gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
	enemy -= enemy_hidden;
	if (bIsOutpost)
		own += gaika.ApproachingSquads(AIPlayer, nApproachDist);

	if (ownC > 8)
		if (ownC >= enemyC + 5)
			if (own + ally >= gaika.MinNeed(AIPlayer, own, ally, enemy))
				break;

	//decide whether to wait approaching army
	{
		SquadList SL;
		Squad squad;
		gaika.GetSquads(SL, AI_COMING + AI_STAYING, AIPlayer, AI_OWN);
		SL.Rewind;
		SL.Lock;
		while (!SL.EOL) {
			squad = SL.Cur;
			if (squad.GAIKAIn == gaika)
				if (squad.LastFightTime > gtStart)
					break;
			if (squad.State == SS_Approach)
				if (squad.GAIKAIn == gaika)
					squad.ClrCmd(SS_Wait, 0, SF_ADVCHOOSER);
				else if (squad.pos.Dist(gaika.Center) > nApproachDist)
					bWait = true;
			SL.Next;
		}
		SL.Unlock;
	}
	if (!bWait)
		break;
	Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

//step 2: siege/capture
while (set.IsEnemy(AIPlayer) && gaika.GetStrat(AIPlayer) == GS_Capture) {
	bool bNoCataps = false;
	int i, state, nMilInCataps, nEnemyInsidePerc, own, ally, enemy, enemy_hidden, ownC, allyC, enemyC, enemyCHidden, nMaxCatapsUnits = 1;

	gaika.Count(AI_STAYING, AIPlayer, ownC, allyC, enemyC, enemyCHidden);
	enemyC -= enemyCHidden;

	if (bIsStronghold)
		enemyC -= set.GetNumSentries();
	if (bIsOutpost)
		enemyC += gaika.Count(AI_ENEMY, AIPlayer, "Peasant");

	gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
	enemy -= enemy_hidden;
	if (bIsOutpost)
		own += gaika.ApproachingSquads(AIPlayer, nApproachDist);
	if (enemy * 8 > own + ally)
		if (!gaika.AllEnemiesInHolder(AIPlayer))
			break;

	if (enemyC > 0)
		nEnemyInsidePerc = set.UnitsCount * 100 / enemyC;
	if (ownC <= 1)
		nMaxCatapsUnits = 0;
	else {
		int nUnitsOut;
		nUnitsOut = MAX(0, enemyC - set.UnitsCount);//invisible units can exist
		nMaxCatapsUnits = ownC * MAX(30, nEnemyInsidePerc) / 100;
		if (ownC - nMaxCatapsUnits <= nUnitsOut)
			nMaxCatapsUnits = nUnitsOut - ownC;
		if (nMaxCatapsUnits <= 0)
			nMaxCatapsUnits = 1;
	}
	if (!bIsOutpost)
		bNoCataps = true;
	else if (enemyC <= 0)
		bNoCataps = true;
	else if (nMaxCatapsUnits <= 0)
		bNoCataps = true;

	state = SS_Capture;
	if (bIsOutpost) {
		if (ownC > enemyC * 6)
			bNoCataps = true;
		else if (enemyC > set.UnitsCount)//units outside
			state = SS_KillAll;
		else
			state = SS_Siege;
	}
	else {
		if (enemy * 8 > own + ally)
			if (gaika.AllEnemiesInHolder(AIPlayer))
				state = SS_Siege;
			else
				break;
		if (state == SS_Capture)
			if (own + ally < 2000)
				if (ownC + allyC < 5)
					if (!set.IsIndependent)
						break;
	}
	if (state == SS_Capture)
		if (nEnemyInsidePerc < 50)
			if (ownC < enemyC * 8)
				state = SS_KillAll;

	{
		SquadList SL;
		Squad squad;
		int squadState;
		gaika.GetSquads(SL, AI_STAYING, AIPlayer, AI_OWN);
		SL.Lock;
		for (0; !SL.EOL; SL.Next) {
			squad = SL.Cur;
			if (squad.TestFlags(SF_PEACEFUL))
				continue;
			if (squad.TestFlags(SF_NOAI))
				continue;

			squadState = squad.State;
			if (squadState != SS_IDLE)
				if (squadState != SS_Wait)
					if (squadState != SS_Approach)
						if (squadState != SS_Flee)
							if (squadState != SS_Capture)
								if (squadState != SS_Siege)
									if (squadState != SS_KillAll)
										if (squadState != SS_Catapult)
											continue;

			if (squadState == SS_Approach)
				if (squad.pos.Dist(gaika.Center) > nApproachDist)
					continue;

			if (state == SS_KillAll) {
				if (bNoCataps) {
					if (squadState != SS_KillAll)
						squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
				}
				else {
					i = squad.Count("Military");
					if (i > 0)
						if (squadState == SS_Catapult)
							nMilInCataps += i;
						else if (squadState != SS_KillAll)
							squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
				}
			}
			else if (state == SS_Capture) {
				if (squadState != SS_Capture)
					squad.SetCmd(SS_Capture, 0, SF_ADVCHOOSER, "capture", hall);
			}
			else if (state == SS_Siege) {
				if (squadState != SS_Catapult)
					if (!squad.Leader.IsHeirOf("GTridentWarrior"))
						if (!squad.Leader.IsHeirOf("BVikingLord"))
							if (!squad.Leader.IsHeirOf("CWarElephant"))
								squad.Siege(hall, MAX(1, squad.Count("Military") / 15), SS_Catapult, SS_Siege);
			}
			else if (state == SS_IDLE)
				squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
		}

		//adjust units in the catapults
		if (!bNoCataps)
			if (state == SS_KillAll)
				if (nMilInCataps < nMaxCatapsUnits) {//add more units to siege
					SL.Rewind;
					for (0; !SL.EOL && nMilInCataps < nMaxCatapsUnits; SL.Next) {
						ObjList ol;
						Squad squad;
						squad = SL.Cur;
						if (squad.State != SS_KillAll)
							continue;
						if (squad.Leader.IsHeirOf("GTridentWarrior"))
							continue;
						if (squad.Leader.IsHeirOf("BVikingLord"))
							continue;
						if (squad.Leader.IsHeirOf("CWarElephant"))
							continue;
						ol = squad.Units;
						squad.Siege(hall, (nMaxCatapsUnits - nMilInCataps + 9) / 10, SS_Catapult, SS_Siege);
						nMilInCataps += ol.count - squad.Units.count;
						if (nMilInCataps > nMaxCatapsUnits) {//return some of the units to the fight
							SquadList sl;
							ObjList olSg;
							olSg = ol;
							olSg.RemoveList(squad.Units);
							for (i = nMilInCataps - nMaxCatapsUnits; i > 0; i -= 1)
								if (olSg.count > 0)
									olSg.Remove(olSg[0]);
							Squadize(olSg, sl, SS_KillAll);
							sl.Rewind;
							sl.Lock;
							for (0; !sl.EOL; sl.Next)
								sl.Cur.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
							sl.Unlock;
						}
						squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
					}
				}
				else if (nMilInCataps > nMaxCatapsUnits) {//unload some units from the catapults
					ObjList ol, olOut;
					SL.Rewind;
					for (0; !SL.EOL && nMilInCataps > nMaxCatapsUnits; SL.Next) {
						Squad squad;
						squad = SL.Cur;
						if (squad.State != SS_Catapult)
							continue;
						for (i = 0; i < squad.Size; i += 1) {
							Catapult cat;
							Unit u;
							u = squad.Units[i].AsUnit();
							if (u.IsValid)
								if (!u.InHolder) {
									olOut.Add(u);
									nMilInCataps -= 1;
									if (nMilInCataps <= nMaxCatapsUnits)
										break;
								}
								else {
									cat = u.GetHolderSett().GetCentralBuilding().AsCatapult();
									if (cat.IsValid)
										ol.Add(cat);
								}
						}
					}
					if (nMilInCataps > nMaxCatapsUnits)
						for (i = 0; i < ol.count; i += 1) {
							Catapult cat;
							cat = ol[i].AsCatapult();
							if (cat.IsValid) {
								Unit u;
								int nCount;
								nCount = cat.settlement.Units.count;
								for (i = 1; i < nCount && nMilInCataps > nMaxCatapsUnits; i += 1) {
									u = cat.settlement.Units[i].AsUnit();
									if (u.IsValid) {
										olOut.Add(u);
										nMilInCataps -= 1;
									}
								}
							}
						}
					if (olOut.count > 0) {
						SquadList sl;
						Squadize(olOut, sl, SS_KillAll);
						sl.Rewind;
						sl.Lock;
						for (0; !sl.EOL; sl.Next)
							sl.Cur.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
						sl.Unlock;
					}
				}
		SL.Unlock;
	}
	Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

{
	SquadList SL;
	Squad squad;
	int nextStrat, squadState;
	nextStrat = gaika.GetStrat(AIPlayer);
	gaika.GetSquads(SL, AI_ALL, AIPlayer, AI_OWN);
	SL.Rewind;
	SL.Lock;
	for (0; !SL.EOL; SL.Next) {
		bool bKillOrClear = false;
		squad = SL.Cur;
		squadState = squad.State;
		if (squadState == SS_Capture)
			bKillOrClear = true;
		else if (squadState == SS_Siege)
			bKillOrClear = true;
		else if (squadState == SS_Catapult)
			bKillOrClear = true;
		else if (squadState == SS_IDLE)
			bKillOrClear = true;
		if (bKillOrClear)
			if (nextStrat == GS_KillEnemies)
				squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
			else if (nextStrat == GS_Capture)//this should manage the case where there are generated units in a tent (currently it can happen only with a human player)
				if (set.IsTTent)
					squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
				else {
					squad.SetState(SS_IDLE);
					squad.SendTo(gaika, 1);
				}
			else {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
	}
	SL.Unlock;
}