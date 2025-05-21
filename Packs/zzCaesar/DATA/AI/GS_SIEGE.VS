//void, GAIKA gaika

Settlement set;

set = gaika.settlement;

if (set.NumGates() > 0) {
	int AIPlayer, gtStart, squadState, state, own, ally, enemy, enemy_hidden;
	SquadList SL;
	Squad squad;
	Gate gate;

	AIPlayer = AIGetPlayer();
	gtStart = GetTime();

	//step 1: gather approaching squads
	while (1) {
		bool bWait = false;
		gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
		if (own + ally >= enemy * 8)
			break;
		if (own + ally >= gaika.MinNeed(AIPlayer, own, ally, enemy))
			break;

		gaika.GetSquads(SL, AI_COMING + AI_STAYING, AIPlayer, AI_OWN);
		SL.Lock;
		for (0; !SL.EOL; SL.Next) {
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
		}
		SL.Unlock;
		if (!bWait)
			break;
		if (gaika.GetStrat(AIPlayer) != GS_Siege)
			break;
		Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
	}

	//step 2: siege (attack gate or kill enemies or capture)
	while (set.IsEnemy(AIPlayer)) {
		bool bEnemiesOut;

		if (gaika.GetStrat(AIPlayer) != GS_Siege) {
			bool bBreak = true;
			gaika.GetSquads(SL, AI_STAYING + AI_COMING, AIPlayer, AI_OWN);
			for (0; !SL.EOL; SL.Next) {
				squad = SL.Cur;//note that this line is not present in the original script
				squadState = squad.State;
				if (squadState == SS_Siege) {
					bBreak = false;
					break;
				}
				if (squadState == SS_Catapult) {
					bBreak = false;
					break;
				}
			}
			if (bBreak)
				break;
		}

		gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
		bEnemiesOut = (enemy - (set.UnitsInHolderEval() + set.EvalSentries())) * 8 > own + ally;

		gaika.GetSquads(SL, AI_STAYING + AI_COMING, AIPlayer, AI_OWN);
		SL.Lock;
		for (0; !SL.EOL; SL.Next) {
			squad = SL.Cur;
			if (squad.TestFlags(SF_PEACEFUL))
				continue;
			squadState = squad.State;
			if (squad.GAIKAIn != gaika)
				if (squadState != SS_IDLE)
					if (squadState != SS_Wait)
						if (squadState != SS_Siege)
							if (squadState != SS_Catapult)
								if (squadState != SS_KillAll)
									continue;
			if (squadState == SS_Flee)
				continue;
			if (squadState == SS_Attach)
				continue;
			if (squad.OrderDest != gaika) {
				squad.SendTo(gaika, 1);//issue order to force squad's AIDest to gaika
				continue;
			}

			gate = set.BestGate(squad.pos);
			if (!gate.IsValid)
				continue;

			if (gate.Inside(squad)) {
				if (bEnemiesOut)
					state = SS_KillAll;
				else
					state = SS_Capture;
			}
			else if (gate.IsVeryBroken())
				state = SS_Enter;
			else
				state = SS_Siege;

			if (squadState != state)
				if (state == SS_Siege) {
					if (squadState != SS_Catapult)
						if (!squad.Leader.IsHeirOf("GTridentWarrior"))
							if (!squad.Leader.IsHeirOf("BVikingLord"))
								if (!squad.Leader.IsHeirOf("CWarElephant"))
									squad.Siege(gate, 2, SS_Catapult, SS_Siege);
				}
				else if (state == SS_KillAll)
					squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
				else if (state == SS_Capture) {
					if (squadState != SS_Capture)
						squad.SetCmd(SS_Capture, 0, SF_ADVCHOOSER, "capture", set.GetCentralBuilding());
				}
				else if (state == SS_IDLE)
					squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
				else if (state == SS_Enter)
					squad.InvadeThroughGate(gate, SS_Enter);
		}
		SL.Unlock;
		Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
	}

	//step 3: clear SS_Siege state and advance to the center of settlement (if next strat is KillAll)
	gaika.GetSquads(SL, AI_ALL, AIPlayer, AI_OWN);
	SL.Lock;
	for (0; !SL.EOL; SL.Next) {
		bool bClear = false;
		squad = SL.Cur;
		squadState = squad.State;
		if (squadState == SS_IDLE)
			bClear = true;
		else if (squadState == SS_Wait)
			bClear = true;
		else if (squadState == SS_Siege)
			bClear = true;
		else if (squadState == SS_Catapult)
			bClear = true;
		else if (squadState == SS_KillAll)
			bClear = true;
		else if (squadState == SS_Capture)
			bClear = true;
		else if (squadState == SS_Enter)
			bClear = true;
		if (bClear) {
			squad.SetState(SS_IDLE);
			squad.SendTo(gaika, 1);
		}
	}
	SL.Unlock;
}