int i, j, sieging;

while (1) {
	Sleep(10000);
	if (!Q_UpperHelper2.IsEmpty()) {
		if (NO_OuterTown.obj.player != 4) {
			StopAIHelper("SiegeOstia2");
			StopAIHelper("SiegeTraitor2");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome2" + i);
			if (!IsAIHelperRunning("SiegeOuterRome2"))
				RunAIHelper("SiegeOuterRome2", "siege", "Q_UpperHelper2", "S_OuterTown");
			sieging = 8;
		}
		else if (NO_Ostia.obj.player != 4) {
			StopAIHelper("SiegeOuterRome2");
			StopAIHelper("SiegeTraitor2");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome2" + i);
			if (!IsAIHelperRunning("SiegeOstia2"))
				RunAIHelper("SiegeOstia2", "siege", "Q_UpperHelper2", "S_Ostia");
			sieging = 9;
		}
		else if (NO_TraitorTown.obj.player == 1) {
			StopAIHelper("SiegeOuterRome2");
			StopAIHelper("SiegeOstia2");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome2" + i);
			if (!IsAIHelperRunning("SiegeTraitor2"))
				RunAIHelper("SiegeTraitor2", "siege", "Q_UpperHelper2", "S_TraitorTown");
			sieging = 10;
		}
		else
			for (i = 1; i < 8; i += 1)
				if (GetNamedObj("NO_InnerTown" + i).obj.player != 4) {
					StopAIHelper("SiegeOuterRome2");
					StopAIHelper("SiegeOstia2");
					StopAIHelper("SiegeTraitor2");
					for (j = 1; j < 8; j += 1)
						if (i != j)
							StopAIHelper("SiegeInnerRome2" + i);
					if (!IsAIHelperRunning("SiegeInnerRome2" + i))
						RunAIHelper("SiegeInnerRome2" + i, "siege", "Q_UpperHelper2", "S_InnerTown" + i);
					sieging = i;
					break;
				}
		Sleep(60000);
		if (NO_OuterTown.obj.player == 4) {
			StopAIHelper("SiegeOuterRome2");
			if (sieging == 8)
				sieging = 0;
		}
		if (NO_Ostia.obj.player == 4) {
			StopAIHelper("SiegeOstia2");
			if (sieging == 9)
				sieging = 0;
		}
		if (NO_TraitorTown.obj.player == 4) {
			StopAIHelper("SiegeTraitor2");
			if (sieging == 10)
				sieging = 0;
		}
		for (i = 1; i < 8; i += 1)
			if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
				StopAIHelper("SiegeInnerRome2" + i);
				if (sieging == i)
					sieging = 0;
			}
		if (sieging == 0)
			Q_UpperHelper2.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_InnerTown3.obj.pos).posRH);
	}
	else
		sieging = 0;
}