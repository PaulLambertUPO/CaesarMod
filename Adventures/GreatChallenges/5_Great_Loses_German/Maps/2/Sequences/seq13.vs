while (1) {
	if (Q_RomanCampDef.count < 30)
		SpawnGroup("Q_RomanCampDef");
	if (!IsAIHelperRunning("RomanCampDef"))
		RunAIHelper("RomanCampDef", "guard area", "Q_RomanCampDef", "A_RomanCamp");
	Sleep(10000);
}