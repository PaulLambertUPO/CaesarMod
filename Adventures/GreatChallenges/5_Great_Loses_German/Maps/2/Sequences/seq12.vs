while (1) {
	if (Q_RoyalGuard.count < 30)
		SpawnGroupInHolder("Q_RoyalGuard", "S_UnbreakableRomanTown");
	if (!IsAIHelperRunning("RomanTownDef"))
		RunAIHelper("RomanTownDef", "guard", "Q_RoyalGuard", "S_UnbreakableRomanTown");
	Sleep(10000);
}