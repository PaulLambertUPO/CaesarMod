while (1) {
	Sleep(5000);

	if (Q_CarthageOutpostDefenders1.count < 15)
		SpawnGroupInHolder("Q_CarthageOutpostDefenders1", "S_CarthageOutpost1");

	if (!Intersect(EnemyObjs(5, cUnit), AreaObjs("A_CarthageOutpost1", cUnit)).IsEmpty()) {
		if (!IsAIHelperRunning("OutpostGuards1"))
			RunAIHelper("OutpostGuards1", "guard area", "Q_CarthageOutpostDefenders1", "A_CarthageOutpost1");
	}
	else if (IsAIHelperRunning("OutpostGuards1")) {
		StopAIHelper("OutpostGuards1");
		Sleep(500);
		Q_CarthageOutpostDefenders1.SetCommand("enter", NO_CarthageOutpost1);
	}

	if (Q_CarthageOutpostDefenders2.count < 15)
		SpawnGroupInHolder("Q_CarthageOutpostDefenders2", "S_CarthageOutpost2");

	if (!Intersect(EnemyObjs(5, cUnit), AreaObjs("A_CarthageOutpost2", cUnit)).IsEmpty()) {
		if (!IsAIHelperRunning("OutpostGuards2"))
			RunAIHelper("OutpostGuards2", "guard area", "Q_CarthageOutpostDefenders2", "A_CarthageOutpost2");
	}
	else if (IsAIHelperRunning("OutpostGuards2")) {
		StopAIHelper("OutpostGuards2");
		Sleep(500);
		Q_CarthageOutpostDefenders2.SetCommand("enter", NO_CarthageOutpost2);
	}
}