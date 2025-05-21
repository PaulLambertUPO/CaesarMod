WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Invaders5_2"), 1, 1000, -1);
if (EnvReadInt("/En_FinalWave") != 1)
	RunAIHelper("DefendCorridor5", "guard area", "G_CorridorDefenders5", "A_Invaders5_2");
Sleep(14000);
SpawnGroup("G_Spawners5");
if (EnvReadInt("/En_FinalWave") != 1) {
	if (!G_Chieftains5.IsEmpty())
		G_Chieftains5.AddToGroup("G_CorridorDefenders5");
	if (!IsAIHelperRunning("DefendCorridor5"))
		RunAIHelper("DefendCorridor5", "guard area", "G_CorridorDefenders5", "A_Invaders5_2");
}
WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);
StopAIHelper("DefendCorridor5");