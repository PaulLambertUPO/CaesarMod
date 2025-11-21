//void, GAIKA gaika

int aiPlayer, nSleepGS, squadState;
point gaikaCenter;
Squad squad;

aiPlayer = AIGetPlayer();
nSleepGS = AIVar(aiPlayer, AIV_Sleep_GS);
gaikaCenter = gaika.Center;

while (gaika.GetStrat(aiPlayer) == GS_Guard) {
	SquadList SL;

	gaika.GetSquads(SL, AI_ALL, aiPlayer, AI_OWN);

	SL.Lock();
	while (!SL.EOL) {
		squad = SL.Cur;
		squadState = squad.State;
		if (squadState == SS_Wait)
			squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
		else if (squadState == SS_Approach)
			if (squad.GAIKAIn == gaika)
				if (squad.AIDest == gaika)
					if (squad.pos.Dist(gaikaCenter) <= 500)
						squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
		SL.Next();
	}
	SL.Unlock();

	Sleep(nSleepGS);
}