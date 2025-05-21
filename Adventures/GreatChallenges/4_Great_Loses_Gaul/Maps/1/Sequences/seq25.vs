Query invaders;
int i, wave;

WaitEmptyQuery(R_Intro, -1);

Sleep(300000 - GetDifficulty() * 60000);

while (EnvReadInt("/En_FinalWave") != 1) {
	Sleep(10000);
	for (i = 1; i <= 8; i += 1) {
		invaders = Group("R_Invaders" + i);
		if (invaders.IsEmpty())
			if (EnvReadInt("/En_AttackCorridor" + i) == 1)
				if (EnvReadInt("/En_FinalWave") != 1) {
					SpawnGroup("R_Invaders" + i).SetCommand("attack", AreaCenter("A_Invaders" + i + "_1"));
					wave += 1;
					EnvWriteInt("/En_CurrentWave", wave);
					EnvWriteInt("/En_AttackCorridor" + i, 2);
				}
		if (!invaders.IsEmpty()) {
			if (!Intersect(AreaObjs("A_Invaders" + i + "_1", cMilitary), invaders).IsEmpty())
				AttackArea(invaders, "A_Invaders" + i + "_2");
			if (!Intersect(AreaObjs("A_Invaders" + i + "_2", cMilitary), invaders).IsEmpty())
				AttackArea(invaders, "A_GergoviaEntrance");
			if (!Intersect(AreaObjs("A_GergoviaEntrance", cMilitary), invaders).IsEmpty()) {
				invaders.AddToGroup("R_Siegers" + i);
				invaders.RemoveFromGroup("R_Invaders");
				invaders.RemoveFromGroup("R_Invaders" + i);
				if (!IsAIHelperRunning("Siege" + i))
					RunAIHelper("Siege" + i, "siege", "R_Siegers" + i, "S_Gergovia");
			}
		}
		else if (EnvReadInt("/En_AttackCorridor" + i) == 2)
			EnvWriteInt("/En_AttackCorridor" + i, 0);
	}
}