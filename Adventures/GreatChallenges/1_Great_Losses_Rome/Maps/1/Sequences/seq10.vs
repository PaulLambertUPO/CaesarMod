int i, j, sieging;

while (1) {
	Sleep(10000);
	if (!Q_LowerHelper1.IsEmpty()) {
		if (NO_OuterTown.obj.player != 4) {
			StopAIHelper("SiegeOstia3");
			StopAIHelper("SiegeTraitor3");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome3" + i);
			if (!IsAIHelperRunning("SiegeOuterRome3"))
				RunAIHelper("SiegeOuterRome3", "siege", "Q_LowerHelper1", "S_OuterTown");
			sieging = 8;
		}
		else if (NO_Ostia.obj.player != 4) {
			StopAIHelper("SiegeOuterRome3");
			StopAIHelper("SiegeTraitor3");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome3" + i);
			if (!IsAIHelperRunning("SiegeOstia3"))
				RunAIHelper("SiegeOstia3", "siege", "Q_LowerHelper1", "S_Ostia");
			sieging = 9;
		}
		else if (NO_TraitorTown.obj.player == 1) {
			StopAIHelper("SiegeOuterRome3");
			StopAIHelper("SiegeOstia3");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome3" + i);
			if (!IsAIHelperRunning("SiegeTraitor3"))
				RunAIHelper("SiegeTraitor3", "siege", "Q_LowerHelper1", "S_TraitorTown");
			sieging = 10;
		}
		else
			for (i = 1; i < 8; i += 1)
				if (GetNamedObj("NO_InnerTown" + i).obj.player != 4) {
					StopAIHelper("SiegeOuterRome3");
					StopAIHelper("SiegeOstia3");
					StopAIHelper("SiegeTraitor3");
					for (j = 1; j < 8; j += 1)
						if (i != j)
							StopAIHelper("SiegeInnerRome3" + i);
					if (!IsAIHelperRunning("SiegeInnerRome3" + i))
						RunAIHelper("SiegeInnerRome3" + i, "siege", "Q_LowerHelper1", "S_InnerTown" + i);
					sieging = i;
					break;
				}
		Sleep(60000);
		if (NO_OuterTown.obj.player == 4) {
			StopAIHelper("SiegeOuterRome3");
			if (sieging == 8)
				sieging = 0;
		}
		if (NO_Ostia.obj.player == 4) {
			StopAIHelper("SiegeOstia3");
			if (sieging == 9)
				sieging = 0;
		}
		if (NO_TraitorTown.obj.player == 4) {
			StopAIHelper("SiegeTraitor3");
			if (sieging == 10)
				sieging = 0;
		}
		for (i = 1; i < 8; i += 1)
			if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
				StopAIHelper("SiegeInnerRome3" + i);
				if (sieging == i)
					sieging = 0;
			}
		if (sieging == 0)
			if (!Q_RomanHeroLR.IsEmpty()) {
				if (!Q_LowerRightRA.IsEmpty())
					Q_LowerRightRA.SetCommand("attach", NO_RomanHeroLR);
				Q_RomanHeroLR.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_OuterTown.obj.pos).posRH);
			}
			else
				Q_LowerRightRA.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_OuterTown.obj.pos).posRH);
	}
	else
		sieging = 0;
}