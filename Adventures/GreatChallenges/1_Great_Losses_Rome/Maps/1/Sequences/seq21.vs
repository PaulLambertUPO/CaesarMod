int i, j, sieging;

while (1) {
	Sleep(10000);
	if (!Q_EliteHelper3.IsEmpty()) {
		if (NO_Ostia.obj.player != 4) {
			StopAIHelper("SiegeOuterRomeE3");
			StopAIHelper("SiegeTraitorE3");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE3" + i);
			if (!IsAIHelperRunning("SiegeOstiaE3"))
				RunAIHelper("SiegeOstiaE3", "siege", "Q_EliteHelper3", "S_Ostia");
			sieging = 9;
		}
		else if (NO_OuterTown.obj.player != 4) {
			StopAIHelper("SiegeOstiaE3");
			StopAIHelper("SiegeTraitorE3");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE3" + i);
			if (!IsAIHelperRunning("SiegeOuterRomeE3"))
				RunAIHelper("SiegeOuterRomeE3", "siege", "Q_EliteHelper3", "S_OuterTown");
			sieging = 8;
		}
		else if (NO_TraitorTown.obj.player == 1) {
			StopAIHelper("SiegeOuterRomeE3");
			StopAIHelper("SiegeOstiaE3");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE3" + i);
			if (!IsAIHelperRunning("SiegeTraitorE3"))
				RunAIHelper("SiegeTraitorE3", "siege", "Q_EliteHelper3", "S_TraitorTown");
			sieging = 10;
		}
		else
			for (i = 1; i < 8; i += 1)
				if (GetNamedObj("NO_InnerTown" + i).obj.player != 4) {
					StopAIHelper("SiegeOuterRomeE3");
					StopAIHelper("SiegeOstiaE3");
					StopAIHelper("SiegeTraitorE3");
					for (j = 1; j < 8; j += 1)
						if (i != j)
							StopAIHelper("SiegeInnerRomeE3" + i);
					if (!IsAIHelperRunning("SiegeInnerRomeE3" + i))
						RunAIHelper("SiegeInnerRomeE3" + i, "siege", "Q_EliteHelper3", "S_InnerTown" + i);
					sieging = i;
					break;
				}
		Sleep(60000);
		if (NO_Ostia.obj.player == 4) {
			StopAIHelper("SiegeOstiaE3");
			if (sieging == 9)
				sieging = 0;
		}
		if (NO_OuterTown.obj.player == 4) {
			StopAIHelper("SiegeOuterRomeE3");
			if (sieging == 8)
				sieging = 0;
		}
		if (NO_TraitorTown.obj.player == 4) {
			StopAIHelper("SiegeTraitorE3");
			if (sieging == 10)
				sieging = 0;
		}
		for (i = 1; i < 8; i += 1)
			if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
				StopAIHelper("SiegeInnerRomeE3" + i);
				if (sieging == i)
					sieging = 0;
			}
		if (sieging == 0)
			if (!Q_LegionCommander3.IsEmpty()) {
				if (!Q_Destroyers3.IsEmpty())
					Q_Destroyers3.SetCommand("attach", NO_LegionCommander3);
				Q_LegionCommander3.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_Ostia.obj.pos).posRH);
			}
			else
				Q_Destroyers3.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_Ostia.obj.pos).posRH);
	}
	else
		sieging = 0;
}