//void, GAIKA gaika

int AIPlayer, gtStart, squadState;
Settlement set;
bool bIsStronghold;
Squad squad;
Unit squadLeader;

AIPlayer = AIGetPlayer();
set = gaika.settlement;
bIsStronghold = set.IsStronghold;
gtStart = GetTime();

//step 1: gather approaching army
if (!set.IsAlly(AIPlayer)) {
	bool bWait = true;
	while (bWait) {
		int own, ally, enemy, enemy_hidden;
		bWait = false;
		gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
		if (enemy <= 0)
			break;
		if (own + ally >= gaika.MinNeed(AIPlayer, own, ally, enemy))
			break;
		{
			SquadList SL;
			gaika.GetSquads(SL, AI_COMING + AI_STAYING, AIPlayer, AI_OWN);
			SL.Lock;
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
				SL.Next;
			}
			SL.Unlock;
		}
		if (gaika.GetStrat(AIPlayer) != GS_KillEnemies)
			break;
		if (bWait)
			Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
	}
}

//step 2: fight the enemy
while (gaika.GetStrat(AIPlayer) == GS_KillEnemies) {
	int state;
	bool bEnter = false;

	if (bIsStronghold) {
		//decide whether to hide in the townhall
		if (set.IsAlly(AIPlayer))
			if (EnvReadInt(set, "EnemiesAlert") == 0) {//EnemiesAlert is set in townhall_behavior_guard.vs
				int our, enemy;
				our = gaika.Eval(AI_STAYING, AIPlayer, AI_OWN + AI_ALLY);
				enemy = gaika.Eval(AI_STAYING + AI_COMING, AIPlayer, AI_ENEMY);
				bEnter = enemy * 2 > our;
			}
		//command gates
		if (bEnter) {
			Sleep(2500);//this is an attempt to delay the gates idling so that the AI does not stop its armies outside the stronghold just to let them being killed without reacting
			set.IdleAllGates();
		}
		else
			set.OpenAllGates();
	}

	//command squads
	{
		SquadList SL;
		gaika.GetSquads(SL, AI_STAYING + AI_COMING, AIPlayer, AI_OWN);
		SL.Lock;
		while (!SL.EOL) {
			bool bSquadEnter;
			bSquadEnter = bEnter;
			squad = SL.Cur;
			squadState = squad.State;

			if (squad.GAIKAIn != gaika)
				if (squadState != SS_Wait) {
					SL.Next;
					continue;
				}

			squadLeader = squad.Leader;

			if (squadLeader.AsShip().IsValid) {
				if (squadLeader.command == "aitransport") {
					SL.Next;
					continue;
				}
				if (squadLeader.command == "boardunit") {
					SL.Next;
					continue;
				}
			}

			if (squad.OrderDest != gaika) {
				squad.SendTo(gaika, 1);//issue order to force squad's AIDest to gaika
				SL.Next;
				continue;
			}

			if (!bSquadEnter)
				if (bIsStronghold)
					if (squadState == SS_Flee || squadState == SS_IDLE || squadState == SS_Enter)
						if (set.IsAlly(AIPlayer))
							if (squadLeader.AsHero().IsValid)
								if (squadLeader.health * 4 < squadLeader.maxhealth * 3)
									bSquadEnter = true;

			if (bSquadEnter)
				state = SS_Enter;
			else
				state = SS_KillAll;

			if (squadState != SS_Flee)
				if (squadState != SS_Attach)
					if (squadState != state)
						if (!squad.TestFlags(SF_PEACEFUL))
							if (state == SS_Enter)
								squad.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", set.GetCentralBuilding());
							else
								squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
			SL.Next;
		}
		SL.Unlock;
	}
	Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

//step 3: clean up
if (bIsStronghold)
	if (set.player == AIPlayer) {
		Sleep(1500);//this is an attempt to delay the gates idling so that the AI does not stop its armies outside the stronghold just to let them being killed without reacting
		set.IdleAllGates();
	}

{
	SquadList SL;
	gaika.GetSquads(SL, AI_ALL, AIPlayer, AI_OWN);
	SL.Lock;
	while (!SL.EOL) {
		bool bStop = false;
		squad = SL.Cur;
		squadState = squad.State;
		if (squadState == SS_KillAll)
			bStop = true;
		else if (squadState == SS_Wait)
			bStop = true;
		else if (squadState == SS_Enter)
			bStop = true;
		else if (squadState == SS_Approach)
			if (squad.GAIKAIn == gaika)
				if (squad.AIDest == gaika)
					bStop = true;
		if (bStop) {
			squad.SetState(SS_IDLE);
			squad.SendTo(gaika, 1);
		}
		SL.Next;
	}
	SL.Unlock;
}