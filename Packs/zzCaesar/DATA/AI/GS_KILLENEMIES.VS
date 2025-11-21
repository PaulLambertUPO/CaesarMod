//void, GAIKA gaika

int aiPlayer, nSleepGS, squadState;
bool bIsStronghold = false;
Settlement set;
Building hall;
Squad squad;

aiPlayer = AIGetPlayer();
nSleepGS = AIVar(aiPlayer, AIV_Sleep_GS);
set = gaika.settlement;
if (set.IsValid)
	if (set.IsStronghold) {
		bIsStronghold = true;
		hall = set.GetCentralBuilding();
	}

//step 1: gather approaching army
{
	bool bWait = true;
	if (set.IsValid)
		if (set.IsAlly(aiPlayer))
			bWait = false;
	if (bWait) {
		int gtStart, own, ally, enemy, enemy_hidden;
		gtStart = GetTime();
		while (gaika.GetStrat(aiPlayer) == GS_KillEnemies) {
			gaika.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
			if (enemy <= 0)
				break;
			if (own + ally >= gaika.MinNeed(aiPlayer, own, ally, enemy))
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
}

//step 2: fight the enemy
{
	Unit squadLeader;
	int ally, enemy, state;
	bool bEnter;

	while (gaika.GetStrat(aiPlayer) == GS_KillEnemies) {
		bEnter = false;

		if (bIsStronghold) {//decide whether to hide in the townhall and command gates
			if (set.IsAlly(aiPlayer))
				if (EnvReadInt(set, "EnemiesAlert") == 0) {//EnemiesAlert is set in "townhall_behavior_guard.vs"
					ally = gaika.Eval(AI_STAYING, aiPlayer, AI_OWN + AI_ALLY);
					enemy = gaika.Eval(AI_STAYING + AI_COMING, aiPlayer, AI_ENEMY);
					bEnter = enemy * 2 > ally;
				}
			if (set.player == aiPlayer)
				if (bEnter) {
					Sleep(2500);//try to delay the gates idling so that the AI does not stop its armies outside the stronghold just to let them being killed without reacting
					set.IdleAllGates();
				}
				else
					set.OpenAllGates();
		}

		//command squads
		{
			SquadList SL;
			gaika.GetSquads(SL, AI_STAYING + AI_COMING, aiPlayer, AI_OWN);
			SL.Lock();
			for (; !SL.EOL; SL.Next()) {
				squad = SL.Cur;
				squadState = squad.State;

				if (squadState != SS_Wait)
					if (squad.GAIKAIn != gaika)
						continue;

				squadLeader = squad.Leader;

				if (squadLeader.AsShip().IsValid) {
					if (squadLeader.command == "aitransport")
						continue;
					if (squadLeader.command == "boardunit")
						continue;
				}

				if (squad.OrderDest != gaika) {
					squad.SendTo(gaika, 1);//issue order to force squad's AIDest to gaika
					continue;
				}

				if (bEnter)
					state = SS_Enter;
				else {
					state = SS_KillAll;
					if (bIsStronghold)
						if (squadState == SS_Flee || squadState == SS_IDLE || squadState == SS_Enter)
							if (squadLeader.AsHero().IsValid)
								if (squadLeader.health * 4 < squadLeader.maxhealth * 3)
									if (set.IsAlly(aiPlayer))
										state = SS_Enter;
				}

				if (squadState != SS_Flee)
					if (squadState != SS_Attach)
						if (squadState != state)
							if (!squad.TestFlags(SF_PEACEFUL))
								if (state == SS_Enter)
									squad.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", hall);
								else
									squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
			}
			SL.Unlock();
		}
		Sleep(nSleepGS);
	}
}

//step 3: clean up
if (bIsStronghold)
	if (set.player == aiPlayer) {
		Sleep(1500);//try to delay the gates idling so that the AI does not stop its armies outside the stronghold just to let them being killed without reacting
		set.IdleAllGates();
	}

{
	SquadList SL;
	gaika.GetSquads(SL, AI_ALL, aiPlayer, AI_OWN);
	SL.Lock();
	while (!SL.EOL) {
		squad = SL.Cur;
		squadState = squad.State;
		if (squadState == SS_KillAll) {
			squad.SetState(SS_IDLE);
			squad.SendTo(gaika, 1);
		}
		else if (squadState == SS_Wait) {
			squad.SetState(SS_IDLE);
			squad.SendTo(gaika, 1);
		}
		else if (squadState == SS_Enter) {
			squad.SetState(SS_IDLE);
			squad.SendTo(gaika, 1);
		}
		else if (squadState == SS_Approach)
			if (squad.GAIKAIn == gaika)
				if (squad.AIDest == gaika) {
					squad.SetState(SS_IDLE);
					squad.SendTo(gaika, 1);
				}
		SL.Next();
	}
	SL.Unlock();
}