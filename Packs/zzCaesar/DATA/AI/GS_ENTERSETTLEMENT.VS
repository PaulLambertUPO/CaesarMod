//void, GAIKA gaika

int aiPlayer, gtStart, nSleepGS, squadState, nAutoTrainStart;
bool bIsStronghold, bEnter, bTrain, bAutoTrain, bE, bT;
Settlement set;
Building hall;
Squad squad;

aiPlayer = AIGetPlayer();
gtStart = GetTime();
nSleepGS = AIVar(aiPlayer, AIV_Sleep_GS);
set = gaika.settlement;//always valid (checked in "GetGAIKAStrat.vs")
bIsStronghold = set.IsStronghold;
hall = set.GetCentralBuilding();

while (gaika.GetStrat(aiPlayer) == GS_EnterSettlement) {
	SquadList SL, slTrain;

	if (GetTime() >= gtStart + 15000) {
		bEnter = true;
		if (bIsStronghold)
			bTrain = gaika.Eval(AI_STAYING + AI_COMING, aiPlayer, AI_ENEMY) <= 0;
		else
			bTrain = false;
	}
	else {
		bTrain = false;
		if (bIsStronghold)
			bEnter = false;
		else
			bEnter = gaika.Eval(AI_STAYING, aiPlayer, AI_ENEMY) > 0;
	}
	bAutoTrain = false;

	gaika.GetSquads(SL, AI_STAYING, aiPlayer, AI_OWN);

	SL.Lock();
	while (!SL.EOL) {
		squad = SL.Cur;
		if (!squad.TestFlags(SF_PEACEFUL + SF_NOAI)) {
			squadState = squad.State;
			if (squadState != SS_Ruins) {
				bE = bEnter;
				bT = bTrain;

				if (squadState == SS_Flee) {
					bE = true;
					bT = true;
				}
				else if (squadState == SS_Train)
					bT = true;
				else if (squadState == SS_Wait) {
					if (!bE)
						squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
				}
				else if (squadState == SS_Approach) {
					if (!bE)
						squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
				}
				else if (squadState != SS_IDLE)
					if (squadState != SS_Enter)
						if (squadState != SS_Heal)
							bE = false;

				if (bIsStronghold)
					if (bT) {
						bT = false;
						bE = false;
						bAutoTrain = true;
					}
					else if (bE) {
						bT = false;
						bE = false;
						bAutoTrain = true;
					}

				if (!bAutoTrain)
					if (bT)
						slTrain.Add(squad);
					else if (bE)
						if (squadState != SS_Enter)
							squad.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", hall);
			}
		}
		SL.Next();
	}
	SL.Unlock();

	if (bIsStronghold) {
		if (bAutoTrain) {
			int nTime;
			nTime = GetTime();
			if (nTime < nAutoTrainStart)
				bAutoTrain = false;
			else if (nTime > nAutoTrainStart + 120000) {
				bAutoTrain = false;
				nAutoTrainStart = nTime + 15000;
			}
		}

		if (EnvReadString(set, "autotrain") == "on") {
			if (!bAutoTrain)
				set.Research("autotrain_stop");
		}
		else if (bAutoTrain)
			set.Research("autotrain_start");
	}

	slTrain.Train(SS_Train, SS_Enter, 4, 10, hall);

	Sleep(nSleepGS);
}

{
	SquadList SL;
	gaika.GetSquads(SL, AI_ALL, aiPlayer, AI_OWN);
	SL.Lock();
	while (!SL.EOL) {
		squad = SL.Cur;
		squadState = squad.State;
		if (squadState == SS_Enter)
			squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
		else if (squadState == SS_Train)
			squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
		else if (squadState == SS_Heal)
			squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
		SL.Next();
	}
	SL.Unlock();
}