WaitQueryCountBetween(G_CorridorDefenders1, 0, 20, -1);
if (EnvReadInt("/En_FinalWave") != 1)
	RunAIHelper("DefendCorridor1", "guard area", "G_CorridorDefenders1", "A_Invaders1_2");
WaitQueryCountBetween(G_CorridorDefenders1, 0, 16, -1);
Sleep(4000);
SpawnGroup("G_Spawners1");
if (EnvReadInt("/En_FinalWave") != 1) {
	if (!G_Chieftains1.IsEmpty())
		G_Chieftains1.AddToGroup("G_CorridorDefenders1");
	if (!IsAIHelperRunning("DefendCorridor1"))
		RunAIHelper("DefendCorridor1", "guard area", "G_CorridorDefenders1", "A_Invaders1_2");
}
WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);
StopAIHelper("DefendCorridor1");