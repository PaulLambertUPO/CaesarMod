//void

int i, idPlayer;
GAIKA g;

AIRun('Prioritize.vs');
AIRun('Recruiter.vs');
AIRun('GAIKAMonitor.vs');
AIRun('SquadMonitor.vs');
AIRun('EconomyMonitor.vs');
AIRun('TacticMonitor.vs');

idPlayer = AIGetPlayer();

Sleep(1200000);//20 minutes

while (1) {
	//decide where to attack
	for (i = 1; i < GAIKACount(); i += 1) {
		g = GetGAIKA(i);
		if (rand(2) == 0)
			if (g.ControlledNeighbors(idPlayer) > 0)
				if (g.settlement.IsEnemy(idPlayer))
					g.SetControlFlag(idPlayer, true);
	}
	Sleep(600000);//10 minutes
	if (GetTime() >= 3000000 || AllyMilEval(idPlayer) > 2 * EnemyMilEval(idPlayer))//50 minutes - time to become aggressive
		for (i = 1; i < GAIKACount(); i += 1) {
			g = GetGAIKA(i);
			if (g.settlement.IsStronghold)
				g.SetControlFlag(idPlayer, true);
		}
}