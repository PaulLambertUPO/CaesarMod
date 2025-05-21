int i, j, sieging;

while (1) {
	Sleep(10000);
	if (!Q_EliteHelper4.IsEmpty()) {
		if (NO_TraitorTown.obj.player == 1) {
			StopAIHelper("SiegeOuterRomeE4");
			StopAIHelper("SiegeOstiaE4");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE4" + i);
			if (!IsAIHelperRunning("SiegeTraitorE4"))
				RunAIHelper("SiegeTraitorE4", "siege", "Q_EliteHelper4", "S_TraitorTown");
			sieging = 10;
		}
		else if (NO_OuterTown.obj.player != 4) {
			StopAIHelper("SiegeOstiaE4");
			StopAIHelper("SiegeTraitorE4");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE4" + i);
			if (!IsAIHelperRunning("SiegeOuterRomeE4"))
				RunAIHelper("SiegeOuterRomeE4", "siege", "Q_EliteHelper4", "S_OuterTown");
			sieging = 8;
		}
		else if (NO_Ostia.obj.player != 4) {
			StopAIHelper("SiegeOuterRomeE4");
			StopAIHelper("SiegeTraitorE4");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE4" + i);
			if (!IsAIHelperRunning("SiegeOstiaE4"))
				RunAIHelper("SiegeOstiaE4", "siege", "Q_EliteHelper4", "S_Ostia");
			sieging = 9;
		}
		else
			for (i = 1; i < 8; i += 1)
				if (GetNamedObj("NO_InnerTown" + i).obj.player != 4) {
					StopAIHelper("SiegeOuterRomeE4");
					StopAIHelper("SiegeOstiaE4");
					StopAIHelper("SiegeTraitorE4");
					for (j = 1; j < 8; j += 1)
						if (i != j)
							StopAIHelper("SiegeInnerRomeE4" + i);
					if (!IsAIHelperRunning("SiegeInnerRomeE4" + i))
						RunAIHelper("SiegeInnerRomeE4" + i, "siege", "Q_EliteHelper4", "S_InnerTown" + i);
					sieging = i;
					break;
				}
		Sleep(60000);
		if (NO_TraitorTown.obj.player == 4) {
			StopAIHelper("SiegeTraitorE4");
			if (sieging == 10)
				sieging = 0;
		}
		if (NO_OuterTown.obj.player == 4) {
			StopAIHelper("SiegeOuterRomeE4");
			if (sieging == 8)
				sieging = 0;
		}
		if (NO_Ostia.obj.player == 4) {
			StopAIHelper("SiegeOstiaE4");
			if (sieging == 9)
				sieging = 0;
		}
		for (i = 1; i < 8; i += 1)
			if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
				StopAIHelper("SiegeInnerRomeE4" + i);
				if (sieging == i)
					sieging = 0;
			}
		if (sieging == 0)
			if (!Q_LegionCommander4.IsEmpty()) {
				if (!Q_Destroyers4.IsEmpty())
					Q_Destroyers4.SetCommand("attach", NO_LegionCommander4);
				Q_LegionCommander4.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_TraitorTown.obj.pos).posRH);
			}
			else
				Q_Destroyers4.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_TraitorTown.obj.pos).posRH);
	}
	else
		sieging = 0;
}