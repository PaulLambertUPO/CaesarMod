int i, prev = 4;

while (1) {
	if (NO_30.obj.player != prev) {
		prev = NO_30.obj.player;
		for (i = 21; i <= 26; i += 1)
			if (prev == 1) {
				GetSettlement("S_Sett" + i).SetPlayer(2);
				Group("T_S_Sett" + i).SetPlayer(2);
			}
			else {
				GetSettlement("S_Sett" + i).SetPlayer(prev);
				Group("T_S_Sett" + i).SetPlayer(prev);
			}
	}
	Sleep(1000);
}