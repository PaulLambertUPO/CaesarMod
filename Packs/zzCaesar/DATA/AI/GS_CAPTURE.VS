//void, GAIKA gaika

int aiPlayer, nSleepGS, squadState;
bool bIsStronghold = false, bIsOutpost = false, bIsTTent = false;
point gaikaCenter;
Settlement set;
Squad squad;

aiPlayer = AIGetPlayer();
nSleepGS = AIVar(aiPlayer, AIV_Sleep_GS);
gaikaCenter = gaika.Center;
set = gaika.settlement;//always valid (checked in "GetGAIKAStrat.vs")
if (set.IsStronghold)
	bIsStronghold = true;
else if (set.IsOutpost)
	bIsOutpost = true;
else if (set.IsTTent)
	bIsTTent = true;

//step 1: gather approaching army
{
	int gtStart, own, ally, enemy, enemy_hidden, ownC, allyC, enemyC, enemyHiddenC;
	bool bWait;
	gtStart = GetTime();
	while (set.IsEnemy(aiPlayer)) {
		if (gaika.GetStrat(aiPlayer) != GS_Capture)
			break;

		//evaluate the gaika army: do not wait for the rest of army if the current one is enough
		gaika.Count(AI_STAYING, aiPlayer, ownC, allyC, enemyC, enemyHiddenC);
		enemyC -= enemyHiddenC;
		if (bIsStronghold)
			enemyC -= set.GetNumSentries();
		else if (bIsOutpost)
			enemyC += gaika.Count(AI_ENEMY, aiPlayer, "Peasant");//count peasants because they contribute to the attack rate of outpost towers
		gaika.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
		enemy -= enemy_hidden;
		if (bIsOutpost)
			own += gaika.ApproachingSquads(aiPlayer, 1600);//important: approach distance value must be like in "GetGAIKAStrat.vs"!
		if (ownC > 8)
			if (ownC >= enemyC + 5)
				if (own + ally >= gaika.MinNeed(aiPlayer, own, ally, enemy))
					break;

		bWait = false;

		//decide whether to wait approaching army
		{
			SquadList SL;
			gaika.GetSquads(SL, AI_COMING + AI_STAYING, aiPlayer, AI_OWN);
			SL.Lock();
			while (!SL.EOL) {
				squad = SL.Cur;
				if (squad.GAIKAIn == gaika)
					if (squad.LastFightTime > gtStart)
						break;
				if (squad.State == SS_Approach)
					if (squad.GAIKAIn == gaika)
						squad.ClrCmd(SS_Wait, 0, SF_ADVCHOOSER);
					else if (!bWait)
						if (squad.pos.Dist(gaikaCenter) > 1600)//important: approach distance value must be like in "GetGAIKAStrat.vs"!
							bWait = true;
				SL.Next();
			}
			SL.Unlock();
		}
		if (!bWait)
			break;
		Sleep(nSleepGS);
	}
}

//step 2: siege/capture
{
	ObjList ol, olSg;
	Building hall;
	Catapult catap;
	Unit u;
	int i, state, nEnemyInsidePerc, nMaxCatapsUnits, nMilInCataps, own, ally, enemy, enemy_hidden, ownC, allyC, enemyC, enemyHiddenC;
	bool bNoCataps;

	hall = set.GetCentralBuilding();

	while (set.IsEnemy(aiPlayer)) {
		if (gaika.GetStrat(aiPlayer) != GS_Capture)
			break;

		gaika.Count(AI_STAYING, aiPlayer, ownC, allyC, enemyC, enemyHiddenC);
		enemyC -= enemyHiddenC;
		if (bIsStronghold)
			enemyC -= set.GetNumSentries();
		else if (bIsOutpost)
			enemyC += gaika.Count(AI_ENEMY, aiPlayer, "Peasant");
		gaika.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
		enemy -= enemy_hidden;
		if (bIsOutpost)
			own += gaika.ApproachingSquads(aiPlayer, 1600);//important: approach distance value must be like in "GetGAIKAStrat.vs"!
		if (enemy * 8 > own + ally)
			if (!gaika.AllEnemiesInHolder(aiPlayer))
				break;

		if (enemyC > 0)
			nEnemyInsidePerc = set.UnitsCount * 100 / enemyC;
		else
			nEnemyInsidePerc = 0;
		if (ownC <= 1)
			nMaxCatapsUnits = 0;
		else {
			nMaxCatapsUnits = ownC * MAX(30, nEnemyInsidePerc) / 100;
			i = MAX(0, enemyC - set.UnitsCount);//invisible units can exist
			if (ownC - nMaxCatapsUnits <= i)
				nMaxCatapsUnits = i - ownC;
			if (nMaxCatapsUnits <= 0)
				nMaxCatapsUnits = 1;
		}
		if (!bIsOutpost)
			bNoCataps = true;
		else if (enemyC <= 0)
			bNoCataps = true;
		else if (nMaxCatapsUnits <= 0)
			bNoCataps = true;
		else
			bNoCataps = false;

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
				if (gaika.AllEnemiesInHolder(aiPlayer))
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
			gaika.GetSquads(SL, AI_STAYING, aiPlayer, AI_OWN);
			SL.Lock();
			for (; !SL.EOL; SL.Next()) {
				squad = SL.Cur;
				if (!squad.TestFlags(SF_PEACEFUL))
					if (!squad.TestFlags(SF_NOAI)) {
						squadState = squad.State;
						if (squadState == SS_Approach) {
							if (squad.pos.Dist(gaikaCenter) > 1600)//important: approach distance value must be like in "GetGAIKAStrat.vs"!
								continue;
						}
						else if (squadState != SS_IDLE)
							if (squadState != SS_Wait)
								if (squadState != SS_Flee)
									if (squadState != SS_Capture)
										if (squadState != SS_Siege)
											if (squadState != SS_KillAll)
												if (squadState != SS_Catapult)
													continue;

						if (state == SS_KillAll)
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
						else if (state == SS_Capture) {
							if (squadState != SS_Capture)
								squad.SetCmd(SS_Capture, 0, SF_ADVCHOOSER, "capture", hall);
						}
						else if (state == SS_Siege) {
							if (squadState != SS_Catapult) {
								u = squad.Leader;
								if (!u.IsHeirOf("GTridentWarrior"))
									if (!u.IsHeirOf("BVikingLord"))
										if (!u.IsHeirOf("CWarElephant"))
											if (!u.IsHeirOf("TValkyrie"))
												squad.Siege(hall, MAX(1, squad.Count("Military") / 15), SS_Catapult, SS_Siege);
							}
						}
						else if (state == SS_IDLE)
							squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
					}
			}

			//adjust units in the catapults
			if (!bNoCataps)
				if (state == SS_KillAll)
					if (nMilInCataps < nMaxCatapsUnits) {//add more units to siege
						for (SL.Rewind(); !SL.EOL; SL.Next()) {
							if (nMilInCataps >= nMaxCatapsUnits)
								break;
							squad = SL.Cur;
							if (squad.State == SS_KillAll) {
								u = squad.Leader;
								if (!u.IsHeirOf("GTridentWarrior"))
									if (!u.IsHeirOf("BVikingLord"))
										if (!u.IsHeirOf("CWarElephant"))
											if (!u.IsHeirOf("TValkyrie")) {
												ol = squad.Units;
												squad.Siege(hall, (nMaxCatapsUnits - nMilInCataps + 9) / 10, SS_Catapult, SS_Siege);
												nMilInCataps += ol.count - squad.Size;
												if (nMilInCataps > nMaxCatapsUnits) {//return some of the units to the fight
													SquadList sl;
													olSg = ol;
													olSg.RemoveList(squad.Units);
													for (i = nMilInCataps - nMaxCatapsUnits; i > 0; i -= 1)
														if (olSg.count > 0)
															olSg.Remove(olSg[0]);
													Squadize(olSg, sl, SS_KillAll);
													sl.Lock();
													for (sl.Rewind(); !sl.EOL; sl.Next())
														sl.Cur.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
													sl.Unlock();
												}
												squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
											}
							}
						}
					}
					else if (nMilInCataps > nMaxCatapsUnits) {//unload some units from the catapults
						ObjList olCataps, olOut;
						for (SL.Rewind(); !SL.EOL; SL.Next()) {
							if (nMilInCataps <= nMaxCatapsUnits)
								break;
							squad = SL.Cur;
							if (squad.State == SS_Catapult) {
								ol = squad.Units;
								for (i = ol.count - 1; i >= 0; i -= 1) {
									u = ol[i].AsUnit();
									if (u.IsAlive)
										if (u.InHolder) {
											catap = u.GetHolderSett().GetCentralBuilding().AsCatapult();
											if (catap.IsValid)
												olCataps.Add(catap);
										}
										else {
											olOut.Add(u);
											nMilInCataps -= 1;
											if (nMilInCataps <= nMaxCatapsUnits)
												break;
										}
								}
							}
						}
						if (nMilInCataps > nMaxCatapsUnits)
							for (i = olCataps.count - 1; i >= 0; i -= 1) {
								catap = olCataps[i].AsCatapult();
								if (catap.IsAlive) {
									ol = catap.settlement.Units;
									for (i = ol.count - 1; i >= 1; i -= 1) {
										if (nMilInCataps <= nMaxCatapsUnits)
											break;
										u = ol[i].AsUnit();
										if (u.IsAlive) {
											olOut.Add(u);
											nMilInCataps -= 1;
										}
									}
								}
							}
						if (olOut.count > 0) {
							SquadList sl;
							Squadize(olOut, sl, SS_KillAll);
							sl.Lock();
							for (sl.Rewind(); !sl.EOL; sl.Next())
								sl.Cur.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
							sl.Unlock();
						}
					}
			SL.Unlock();
		}
		Sleep(nSleepGS);
	}
}

{
	SquadList SL;
	int nextStrat;
	bool bKillOrClear;
	nextStrat = gaika.GetStrat(aiPlayer);
	gaika.GetSquads(SL, AI_ALL, aiPlayer, AI_OWN);
	SL.Lock();
	while (!SL.EOL) {
		bKillOrClear = false;
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
				if (bIsTTent)
					squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
				else {
					squad.SetState(SS_IDLE);
					squad.SendTo(gaika, 1);
				}
			else {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
		SL.Next();
	}
	SL.Unlock();
}