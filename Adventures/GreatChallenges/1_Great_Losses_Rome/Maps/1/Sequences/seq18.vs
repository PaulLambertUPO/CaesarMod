int i, j, sieging;

while (1) {
	Sleep(10000);
	if (!Q_EliteHelper1.IsEmpty()) {
		if (NO_TraitorTown.obj.player == 1) {
			StopAIHelper("SiegeOuterRomeE1");
			StopAIHelper("SiegeOstiaE1");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE1" + i);
			if (!IsAIHelperRunning("SiegeTraitorE1"))
				RunAIHelper("SiegeTraitorE1", "siege", "Q_EliteHelper1", "S_TraitorTown");
			sieging = 10;
		}
		else if (NO_OuterTown.obj.player != 4) {
			StopAIHelper("SiegeOstiaE1");
			StopAIHelper("SiegeTraitorE1");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE1" + i);
			if (!IsAIHelperRunning("SiegeOuterRomeE1"))
				RunAIHelper("SiegeOuterRomeE1", "siege", "Q_EliteHelper1", "S_OuterTown");
			sieging = 8;
		}
		else if (NO_Ostia.obj.player != 4) {
			StopAIHelper("SiegeOuterRomeE1");
			StopAIHelper("SiegeTraitorE1");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE1" + i);
			if (!IsAIHelperRunning("SiegeOstiaE1"))
				RunAIHelper("SiegeOstiaE1", "siege", "Q_EliteHelper1", "S_Ostia");
			sieging = 9;
		}
		else
			for (i = 1; i < 8; i += 1)
				if (GetNamedObj("NO_InnerTown" + i).obj.player != 4) {
					StopAIHelper("SiegeOuterRomeE1");
					StopAIHelper("SiegeOstiaE1");
					StopAIHelper("SiegeTraitorE1");
					for (j = 1; j < 8; j += 1)
						if (i != j)
							StopAIHelper("SiegeInnerRomeE1" + i);
					if (!IsAIHelperRunning("SiegeInnerRomeE1" + i))
						RunAIHelper("SiegeInnerRomeE1" + i, "siege", "Q_EliteHelper1", "S_InnerTown" + i);
					sieging = i;
					break;
				}
		Sleep(60000);
		if (NO_TraitorTown.obj.player == 4) {
			StopAIHelper("SiegeTraitorE1");
			if (sieging == 10)
				sieging = 0;
		}
		if (NO_OuterTown.obj.player == 4) {
			StopAIHelper("SiegeOuterRomeE1");
			if (sieging == 8)
				sieging = 0;
		}
		if (NO_Ostia.obj.player == 4) {
			StopAIHelper("SiegeOstiaE1");
			if (sieging == 9)
				sieging = 0;
		}
		for (i = 1; i < 8; i += 1)
			if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
				StopAIHelper("SiegeInnerRomeE1" + i);
				if (sieging == i)
					sieging = 0;
			}
		if (sieging == 0)
			if (!Q_LegionCommander1.IsEmpty()) {
				if (!Q_Destroyers1.IsEmpty())
					Q_Destroyers1.SetCommand("attach", NO_LegionCommander1);
				Q_LegionCommander1.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_TraitorTown.obj.pos).posRH);
			}
			else
				Q_Destroyers1.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_TraitorTown.obj.pos).posRH);
	}
	else
		sieging = 0;
}