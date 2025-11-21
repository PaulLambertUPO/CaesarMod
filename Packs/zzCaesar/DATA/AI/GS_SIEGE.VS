//void, GAIKA gaika

Settlement set;

set = gaika.settlement;//always valid (checked in "GetGAIKAStrat.vs")

if (set.NumGates > 0) {
	int aiPlayer, nSleepGS, squadState, own, ally, enemy, enemy_hidden;
	Squad squad;

	aiPlayer = AIGetPlayer();
	nSleepGS = AIVar(aiPlayer, AIV_Sleep_GS);

	//step 1: gather approaching squads
	{
		int gtStart, ownAndAlly;
		bool bWait;
		gtStart = GetTime();
		while (gaika.GetStrat(aiPlayer) == GS_Siege) {
			gaika.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
			ownAndAlly = own + ally;
			if (ownAndAlly >= enemy * 8)
				break;
			if (ownAndAlly >= gaika.MinNeed(aiPlayer, own, ally, enemy))
				break;
			bWait = false;
			{
				SquadList SL;
				gaika.GetSquads(SL, AI_COMING + AI_STAYING, aiPlayer, AI_OWN);
				SL.Lock();
				while (!SL.EOL) {
					squad = SL.Cur;
					if (squad.GAIKAIn == gaika)
						if (squad.LastFightTime > gtStart) {
							bWait = false;
							break;
						}
					if (squad.State == SS_Approach)
						if (squad.GAIKAIn == gaika)
							squad.ClrCmd(SS_Wait, 0, SF_ADVCHOOSER);
						else
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

	//step 2: siege (attack gate or kill enemies or capture)
	{
		Gate gate;
		Building hall;
		Unit squadLeader;
		int state;
		bool bBreak, bEnemiesOut;

		hall = set.GetCentralBuilding();

		while (set.IsEnemy(aiPlayer)) {
			if (gaika.GetStrat(aiPlayer) != GS_Siege) {
				SquadList SL;
				bBreak = true;
				gaika.GetSquads(SL, AI_STAYING + AI_COMING, aiPlayer, AI_OWN);
				while (!SL.EOL) {
					squadState = SL.Cur.State;//note that Cur is not used in the original script (which means that only the last squad used in other parts is checked)
					if (squadState == SS_Siege) {
						bBreak = false;
						break;
					}
					if (squadState == SS_Catapult) {
						bBreak = false;
						break;
					}
					SL.Next();
				}
				if (bBreak)
					break;
			}
			gaika.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
			bEnemiesOut = (enemy - (set.UnitsInHolderEval() + set.EvalSentries())) * 8 > own + ally;
			{
				SquadList SL;
				gaika.GetSquads(SL, AI_STAYING + AI_COMING, aiPlayer, AI_OWN);
				SL.Lock();
				for (; !SL.EOL; SL.Next()) {
					squad = SL.Cur;
					if (!squad.TestFlags(SF_PEACEFUL)) {
						squadState = squad.State;
						if (squadState != SS_Flee)
							if (squadState != SS_Attach) {
								if (squadState != SS_IDLE)
									if (squadState != SS_Wait)
										if (squadState != SS_Siege)
											if (squadState != SS_Catapult)
												if (squadState != SS_KillAll)
													if (squad.GAIKAIn != gaika)
														continue;
								if (squad.OrderDest != gaika) {
									squad.SendTo(gaika, 1);//issue order to force squad's AIDest to gaika
									continue;
								}
								gate = set.BestGate(squad.pos);
								if (gate.IsValid) {//it should always be valid
									if (gate.Inside(squad)) {
										if (bEnemiesOut)
											state = SS_KillAll;
										else
											state = SS_Capture;
									}
									else if (gate.IsVeryBroken)
										state = SS_Enter;
									else
										state = SS_Siege;

									if (squadState != state)
										if (state == SS_Siege) {
											if (squadState != SS_Catapult) {
												squadLeader = squad.Leader;
												if (!squadLeader.IsHeirOf("GTridentWarrior"))
													if (!squadLeader.IsHeirOf("BVikingLord"))
														if (!squadLeader.IsHeirOf("CWarElephant"))
															if (!squadLeader.IsHeirOf("TValkyrie"))
																squad.Siege(gate, 2, SS_Catapult, SS_Siege);
											}
										}
										else if (state == SS_KillAll)
											squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
										else if (state == SS_Capture) {
											if (squadState != SS_Capture)
												squad.SetCmd(SS_Capture, 0, SF_ADVCHOOSER, "capture", hall);
										}
										else if (state == SS_IDLE)
											squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
										else if (state == SS_Enter)
											squad.InvadeThroughGate(gate, SS_Enter);
								}
							}
					}
				}
				SL.Unlock();
			}
			Sleep(nSleepGS);
		}
	}

	//step 3: clear SS_Siege state and advance to the center of settlement (if next strat is KillAll)
	{
		SquadList SL;
		gaika.GetSquads(SL, AI_ALL, aiPlayer, AI_OWN);
		SL.Lock();
		while (!SL.EOL) {
			squad = SL.Cur;
			squadState = squad.State;
			if (squadState == SS_IDLE) {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
			else if (squadState == SS_Wait) {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
			else if (squadState == SS_Siege) {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
			else if (squadState == SS_Catapult) {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
			else if (squadState == SS_KillAll) {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
			else if (squadState == SS_Capture) {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
			else if (squadState == SS_Enter) {
				squad.SetState(SS_IDLE);
				squad.SendTo(gaika, 1);
			}
			SL.Next();
		}
		SL.Unlock();
	}
}