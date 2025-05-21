WaitQueryCountBetween(G_CorridorDefenders2, 0, 18, -1);
if (EnvReadInt("/En_FinalWave") != 1)
	RunAIHelper("DefendCorridor2", "guard area", "G_CorridorDefenders2", "A_Invaders2_1");
WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Invaders2_2"), 1, 1000, -1);
Sleep(10000);
StopAIHelper("DefendCorridor2");
SpawnGroup("G_Spawners2");
if (EnvReadInt("/En_FinalWave") != 1) {
	if (!G_Chieftains2.IsEmpty())
		G_Chieftains2.AddToGroup("G_CorridorDefenders2");
	RunAIHelper("DefendCorridor2", "guard area", "G_CorridorDefenders2", "A_Invaders2_2");
}
WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);
StopAIHelper("DefendCorridor2");