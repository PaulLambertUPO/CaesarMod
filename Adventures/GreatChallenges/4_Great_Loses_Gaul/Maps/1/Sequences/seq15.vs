WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Invaders7_2"), 1, 1000, -1);
Sleep(16000);
SpawnGroup("G_Spawners7");
if (EnvReadInt("/En_FinalWave") != 1) {
	if (!G_Chieftains7.IsEmpty())
		G_Chieftains7.AddToGroup("G_CorridorDefenders7");
	if (!IsAIHelperRunning("DefendCorridor7"))
		RunAIHelper("DefendCorridor7", "guard area", "G_CorridorDefenders7", "A_Invaders7_2");
}
WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);
StopAIHelper("DefendCorridor7");