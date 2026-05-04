//void

int aiPlayer, gaikas, i;
GAIKA g;

AIRun('Prioritize.vs');
AIRun('Recruiter.vs');
AIRun('GAIKAMonitor.vs');
AIRun('SquadMonitor.vs');
AIRun('EconomyMonitor.vs');
AIRun('TacticMonitor.vs');

Sleep(900000);

aiPlayer = AIGetPlayer();
gaikas = GAIKACount;

while (true) {
	for (i = 1; i < gaikas; i += 1)//decide where to attack
		if (rand(2) == 0) {
			g = GetGAIKA(i);
			if (g.ControlledNeighbors(aiPlayer) > 0)
				if (g.settlement.IsValid)
					if (g.settlement.IsEnemy(aiPlayer))
						g.SetControlFlag(aiPlayer, true);
		}

	Sleep(300000);

	if (GetTime() >= 2100000)//35 minutes - time to become aggressive
		for (i = 1; i < gaikas; i += 1) {
			g = GetGAIKA(i);
			if (g.settlement.IsValid)
				if (g.settlement.IsStronghold)
					g.SetControlFlag(aiPlayer, true);
		}
	else if (AllyMilEval(aiPlayer) > 2 * EnemyMilEval(aiPlayer))//great advantage - time to become aggressive
		for (i = 1; i < gaikas; i += 1) {
			g = GetGAIKA(i);
			if (g.settlement.IsValid)
				if (g.settlement.IsStronghold)
					g.SetControlFlag(aiPlayer, true);
		}

	Sleep(1000);
}