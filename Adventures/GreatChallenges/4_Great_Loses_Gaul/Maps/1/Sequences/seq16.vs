WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Invaders8_1"), 1, 1000, -1);
if (EnvReadInt("/En_FinalWave") != 1)
	RunAIHelper("DefendCorridor8", "guard area", "G_CorridorDefenders8", "A_Invaders8_1");
WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Invaders8_2"), 1, 1000, -1);
Sleep(5000);
StopAIHelper("DefendCorridor8");
SpawnGroup("G_Spawners8");
if (EnvReadInt("/En_FinalWave") != 1) {
	if (!G_Chieftains8.IsEmpty())
		G_Chieftains8.AddToGroup("G_CorridorDefenders8");
	RunAIHelper("DefendCorridor8", "guard area", "G_CorridorDefenders8", "A_Invaders8_2");
}
WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);
StopAIHelper("DefendCorridor8");