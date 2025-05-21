WaitQueryCountBetween(G_CorridorDefenders3, 0, 30, -1);
if (EnvReadInt("/En_FinalWave") != 1)
	RunAIHelper("DefendCorridor3", "guard area", "G_CorridorDefenders3", "A_Invaders3_1");
WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Invaders3_2"), 1, 1000, -1);
Sleep(6000);
StopAIHelper("DefendCorridor3");
SpawnGroup("G_Spawners3");
if (EnvReadInt("/En_FinalWave") != 1) {
	if (!G_Chieftains3.IsEmpty())
		G_Chieftains3.AddToGroup("G_CorridorDefenders3");
	RunAIHelper("DefendCorridor3", "guard area", "G_CorridorDefenders3", "A_Invaders3_2");
}
WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);
StopAIHelper("DefendCorridor3");