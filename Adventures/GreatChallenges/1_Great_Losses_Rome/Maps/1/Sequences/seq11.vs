int i, j, sieging;

while (1) {
	Sleep(10000);
	if (!Q_LowerHelper2.IsEmpty()) {
		if (NO_OuterTown.obj.player != 4) {
			StopAIHelper("SiegeOstia4");
			StopAIHelper("SiegeTraitor4");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome4" + i);
			if (!IsAIHelperRunning("SiegeOuterRome4"))
				RunAIHelper("SiegeOuterRome4", "siege", "Q_LowerHelper2", "S_OuterTown");
			sieging = 8;
		}
		else if (NO_Ostia.obj.player != 4) {
			StopAIHelper("SiegeOuterRome4");
			StopAIHelper("SiegeTraitor4");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome4" + i);
			if (!IsAIHelperRunning("SiegeOstia4"))
				RunAIHelper("SiegeOstia4", "siege", "Q_LowerHelper2", "S_Ostia");
			sieging = 9;
		}
		else if (NO_TraitorTown.obj.player == 1) {
			StopAIHelper("SiegeOuterRome4");
			StopAIHelper("SiegeOstia4");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome4" + i);
			if (!IsAIHelperRunning("SiegeTraitor4"))
				RunAIHelper("SiegeTraitor4", "siege", "Q_LowerHelper2", "S_TraitorTown");
			sieging = 10;
		}
		else
			for (i = 1; i < 8; i += 1)
				if (GetNamedObj("NO_InnerTown" + i).obj.player != 4) {
					StopAIHelper("SiegeOuterRome4");
					StopAIHelper("SiegeOstia4");
					StopAIHelper("SiegeTraitor4");
					for (j = 1; j < 8; j += 1)
						if (i != j)
							StopAIHelper("SiegeInnerRome4" + i);
					if (!IsAIHelperRunning("SiegeInnerRome4" + i))
						RunAIHelper("SiegeInnerRome4" + i, "siege", "Q_LowerHelper2", "S_InnerTown" + i);
					sieging = i;
					break;
				}
		Sleep(60000);
		if (NO_OuterTown.obj.player == 4) {
			StopAIHelper("SiegeOuterRome4");
			if (sieging == 8)
				sieging = 0;
		}
		if (NO_Ostia.obj.player == 4) {
			StopAIHelper("SiegeOstia4");
			if (sieging == 9)
				sieging = 0;
		}
		if (NO_TraitorTown.obj.player == 4) {
			StopAIHelper("SiegeTraitor4");
			if (sieging == 10)
				sieging = 0;
		}
		for (i = 1; i < 8; i += 1)
			if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
				StopAIHelper("SiegeInnerRome4" + i);
				if (sieging == i)
					sieging = 0;
			}
		if (sieging == 0)
			Q_LowerHelper2.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_InnerTown2.obj.pos).posRH);
	}
	else
		sieging = 0;
}