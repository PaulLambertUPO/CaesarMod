int i, j, sieging;

while (1) {
	Sleep(10000);
	if (!Q_EliteHelper2.IsEmpty()) {
		if (NO_OuterTown.obj.player != 4) {
			StopAIHelper("SiegeOstiaE2");
			StopAIHelper("SiegeTraitorE2");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE2" + i);
			if (!IsAIHelperRunning("SiegeOuterRomeE2"))
				RunAIHelper("SiegeOuterRomeE2", "siege", "Q_EliteHelper2", "S_OuterTown");
			sieging = 8;
		}
		else if (NO_Ostia.obj.player != 4) {
			StopAIHelper("SiegeOuterRomeE2");
			StopAIHelper("SiegeTraitorE2");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE2" + i);
			if (!IsAIHelperRunning("SiegeOstiaE2"))
				RunAIHelper("SiegeOstiaE2", "siege", "Q_EliteHelper2", "S_Ostia");
			sieging = 9;
		}
		else if (NO_TraitorTown.obj.player == 1) {
			StopAIHelper("SiegeOuterRomeE2");
			StopAIHelper("SiegeOstiaE2");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRomeE2" + i);
			if (!IsAIHelperRunning("SiegeTraitorE2"))
				RunAIHelper("SiegeTraitorE2", "siege", "Q_EliteHelper2", "S_TraitorTown");
			sieging = 10;
		}
		else
			for (i = 1; i < 8; i += 1)
				if (GetNamedObj("NO_InnerTown" + i).obj.player != 4) {
					StopAIHelper("SiegeOuterRomeE2");
					StopAIHelper("SiegeOstiaE2");
					StopAIHelper("SiegeTraitorE2");
					for (j = 1; j < 8; j += 1)
						if (i != j)
							StopAIHelper("SiegeInnerRomeE2" + i);
					if (!IsAIHelperRunning("SiegeInnerRomeE2" + i))
						RunAIHelper("SiegeInnerRomeE2" + i, "siege", "Q_EliteHelper2", "S_InnerTown" + i);
					sieging = i;
					break;
				}
		Sleep(60000);
		if (NO_OuterTown.obj.player == 4) {
			StopAIHelper("SiegeOuterRomeE2");
			if (sieging == 8)
				sieging = 0;
		}
		if (NO_Ostia.obj.player == 4) {
			StopAIHelper("SiegeOstiaE2");
			if (sieging == 9)
				sieging = 0;
		}
		if (NO_TraitorTown.obj.player == 4) {
			StopAIHelper("SiegeTraitorE2");
			if (sieging == 10)
				sieging = 0;
		}
		for (i = 1; i < 8; i += 1)
			if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
				StopAIHelper("SiegeInnerRomeE2" + i);
				if (sieging == i)
					sieging = 0;
			}
		if (sieging == 0)
			if (!Q_LegionCommander2.IsEmpty()) {
				if (!Q_Destroyers2.IsEmpty())
					Q_Destroyers2.SetCommand("attach", NO_LegionCommander2);
				Q_LegionCommander2.SetCommand("attack", Q_HannibalArmy.NearestObj(AreaCenter("A_DetectAmbush1")).posRH);
			}
			else
				Q_Destroyers2.SetCommand("attack", Q_HannibalArmy.NearestObj(AreaCenter("A_DetectAmbush1")).posRH);
	}
	else
		sieging = 0;
}