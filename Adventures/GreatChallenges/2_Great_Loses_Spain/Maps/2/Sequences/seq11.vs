int i, wait_timer;

wait_timer = 35000 - GetDifficulty() * 10000;

while (1) {
	if (Group("VaniArmy").count > 15) {
		Settlement settle;
		for (i = 1; i <= 12; i += 1)
			if (GetSettlement("settle" + i).player != 4) {
				settle = GetSettlement("settle" + i);
				break;
			}
		if (!settle.IsValid)
			settle = GetSettlement("S_MainTown");
		if (settle.IsValid) {
			if (!IsAIHelperRunning("SiegeIberians"))
				RunAIHelper("SiegeIberians", "siege", "VaniArmy", settle.name);
			while (Group("VaniArmy").count > 15) {
				if (settle.player == 4) {
					Sleep(wait_timer);
					break;
				}
				Sleep(1500);
			}
			StopAIHelper("SiegeIberians");
		}
	}
	else {
		EnvWriteInt("/NeedArmy", 1);
		Sleep(wait_timer);
	}
	Sleep(2000);
}