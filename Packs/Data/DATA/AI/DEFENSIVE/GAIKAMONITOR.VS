//void

GAIKA gaika;
int aiPlayer, nLastGaika, strat, i;
bool interruptPassing, synchApproach;

Sleep(500 + rand(501));

aiPlayer = AIGetPlayer();
nLastGaika = GAIKACount - 1;

interruptPassing = AIVar(aiPlayer, AIV_InterruptPassing) != 0;
synchApproach = AIVar(aiPlayer, AIV_SynchApproach) != 0;

while (!LAIKA(aiPlayer, nLastGaika).Prioritized(aiPlayer))
	Sleep(2000);

while (1) {
	for (i = 1; i <= nLastGaika; i += 1) {
		gaika = LAIKA(aiPlayer, i);
		if (gaika.settlement.IsValid)
			if (gaika.settlement.IsOwn(aiPlayer))
				gaika.SetControlFlag(aiPlayer, true);
		if (gaika.MilitaryPresence(aiPlayer)) {
			if (interruptPassing)
				gaika.AIRun("GSH_InterruptPassing.vs", aiPlayer);
			if (synchApproach)
				gaika.AIRun("GSH_SynchApproach.vs", aiPlayer);
			if (gaika.StratRunning(aiPlayer) == GS_NONE) {
				strat = gaika.GetStrat(aiPlayer);
				if (strat != GS_NONE)
					gaika.RunStrat(aiPlayer, strat);
			}
		}
		Sleep(250);
	}
}