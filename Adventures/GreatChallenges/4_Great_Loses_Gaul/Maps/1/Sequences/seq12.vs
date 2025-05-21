WaitQueryCountBetween(G_CorridorDefenders4, 0, 24, -1);
if (EnvReadInt("/En_FinalWave") != 1)
	RunAIHelper("DefendCorridor4", "guard area", "G_CorridorDefenders4", "A_Invaders4_1");
WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Invaders4_2"), 1, 1000, -1);
Sleep(8000);
StopAIHelper("DefendCorridor4");
SpawnGroup("G_Spawners4");
if (EnvReadInt("/En_FinalWave") != 1) {
	if (!G_Chieftains4.IsEmpty())
		G_Chieftains4.AddToGroup("G_CorridorDefenders4");
	RunAIHelper("DefendCorridor4", "guard area", "G_CorridorDefenders4", "A_Invaders4_2");
}
WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);
StopAIHelper("DefendCorridor4");