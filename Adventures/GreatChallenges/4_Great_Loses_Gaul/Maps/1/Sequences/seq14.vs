WaitQueryCountBetween(G_CorridorDefenders6, 0, 24, -1);
if (EnvReadInt("/En_FinalWave") != 1)
	RunAIHelper("DefendCorridor6", "guard area", "G_CorridorDefenders6", "A_Invaders6_1");
WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Invaders6_2"), 1, 1000, -1);
Sleep(8000);
StopAIHelper("DefendCorridor6");
SpawnGroup("G_Spawners6");
if (EnvReadInt("/En_FinalWave") != 1) {
	if (!G_Chieftains6.IsEmpty())
		G_Chieftains6.AddToGroup("G_CorridorDefenders6");
	RunAIHelper("DefendCorridor6", "guard area", "G_CorridorDefenders6", "A_Invaders6_2");
}
WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);
StopAIHelper("DefendCorridor6");