//void, GAIKA gaika

int AIPlayer, gtStart, squadState, nAutoTrainStart, nAutoTrainRestartPeriod = 120000, nAutoTrainNoTrainPeriod = 15000;
bool bIsStronghold;
Settlement set;
Building hall;
SquadList SL;
Squad squad;

AIPlayer = AIGetPlayer();
gtStart = GetTime();
set = gaika.settlement;
bIsStronghold = set.IsStronghold;
hall = set.GetCentralBuilding();

while (1) {
	SquadList slTrain;
	bool bStarted, bEnter, bTrain, bAutoTrain = false;

	bStarted = gtStart + 15000 <= GetTime();
	bEnter = bStarted;
	bTrain = bStarted && bIsStronghold;
	if (bTrain)
		if (gaika.Eval(AI_STAYING + AI_COMING, AIPlayer, AI_ENEMY) > 0)
			bTrain = false;
	if (!bEnter)
		if (!bIsStronghold)
			if (gaika.Eval(AI_STAYING, AIPlayer, AI_ENEMY) > 0)
				bEnter = true;

	gaika.GetSquads(SL, AI_STAYING, AIPlayer, AI_OWN);
	SL.Lock;
	while (!SL.EOL) {
		squad = SL.Cur;
		if (!squad.TestFlags(SF_PEACEFUL + SF_NOAI)) {
			squadState = squad.State;
			if (squadState != SS_Ruins) {
				bool bE, bT;
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
				if (bT || bE)
					if (bIsStronghold) {
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
		SL.Next;
	}
	SL.Unlock;

	if (bIsStronghold) {
		if (bAutoTrain) {
			int nTime;
			nTime = GetTime();
			if (nTime < nAutoTrainStart)
				bAutoTrain = false;
			else if (nTime > nAutoTrainStart + nAutoTrainRestartPeriod) {
				bAutoTrain = false;
				nAutoTrainStart = nTime + nAutoTrainNoTrainPeriod;
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

	if (gaika.GetStrat(AIPlayer) != GS_EnterSettlement)
		break;

	Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

gaika.GetSquads(SL, AI_ALL, AIPlayer, AI_OWN);
SL.Lock;
while (!SL.EOL) {
	squad = SL.Cur;
	squadState = squad.State;
	if (squadState == SS_Enter)
		squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
	else if (squadState == SS_Train)
		squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
	else if (squadState == SS_Heal)
		squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
	SL.Next;
}
SL.Unlock;