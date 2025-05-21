int i, j, sieging;

while (1) {
	Sleep(10000);
	if (!Q_UpperHelper1.IsEmpty()) {
		if (NO_OuterTown.obj.player != 4) {
			StopAIHelper("SiegeOstia1");
			StopAIHelper("SiegeTraitor1");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome1" + i);
			if (!IsAIHelperRunning("SiegeOuterRome1"))
				RunAIHelper("SiegeOuterRome1", "siege", "Q_UpperHelper1", "S_OuterTown");
			sieging = 8;
		}
		else if (NO_Ostia.obj.player != 4) {
			StopAIHelper("SiegeOuterRome1");
			StopAIHelper("SiegeTraitor1");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome1" + i);
			if (!IsAIHelperRunning("SiegeOstia1"))
				RunAIHelper("SiegeOstia1", "siege", "Q_UpperHelper1", "S_Ostia");
			sieging = 9;
		}
		else if (NO_TraitorTown.obj.player == 1) {
			StopAIHelper("SiegeOuterRome1");
			StopAIHelper("SiegeOstia1");
			for (i = 1; i < 8; i += 1)
				StopAIHelper("SiegeInnerRome1" + i);
			if (!IsAIHelperRunning("SiegeTraitor1"))
				RunAIHelper("SiegeTraitor1", "siege", "Q_UpperHelper1", "S_TraitorTown");
			sieging = 10;
		}
		else
			for (i = 1; i < 8; i += 1)
				if (GetNamedObj("NO_InnerTown" + i).obj.player != 4) {
					StopAIHelper("SiegeOuterRome1");
					StopAIHelper("SiegeOstia1");
					StopAIHelper("SiegeTraitor1");
					for (j = 1; j < 8; j += 1)
						if (i != j)
							StopAIHelper("SiegeInnerRome1" + i);
					if (!IsAIHelperRunning("SiegeInnerRome1" + i))
						RunAIHelper("SiegeInnerRome1" + i, "siege", "Q_UpperHelper1", "S_InnerTown" + i);
					sieging = i;
					break;
				}
		Sleep(60000);
		if (NO_OuterTown.obj.player == 4) {
			StopAIHelper("SiegeOuterRome1");
			if (sieging == 8)
				sieging = 0;
		}
		if (NO_Ostia.obj.player == 4) {
			StopAIHelper("SiegeOstia1");
			if (sieging == 9)
				sieging = 0;
		}
		if (NO_TraitorTown.obj.player == 4) {
			StopAIHelper("SiegeTraitor1");
			if (sieging == 10)
				sieging = 0;
		}
		for (i = 1; i < 8; i += 1)
			if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
				StopAIHelper("SiegeInnerRome1" + i);
				if (sieging == i)
					sieging = 0;
			}
		if (sieging == 0)
			if (!Q_RomanHeroUR.IsEmpty()) {
				if (!Q_UpperRightRA.IsEmpty())
					Q_UpperRightRA.SetCommand("attach", NO_RomanHeroUR);
				Q_RomanHeroUR.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_InnerTown1.obj.pos).posRH);
			}
			else
				Q_UpperRightRA.SetCommand("attack", Q_HannibalArmy.NearestObj(NO_InnerTown1.obj.pos).posRH);
	}
	else
		sieging = 0;
}