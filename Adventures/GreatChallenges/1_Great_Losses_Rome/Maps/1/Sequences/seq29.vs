int i;

while (1) {
	Sleep(120000);
	if (NO_OuterTown.obj.player == 4) {
		GetSettlement("S_OuterTown").SetGold(2000);
		GetSettlement("S_OuterTown").SetFood(2000);
	}
	for (i = 1; i < 8; i += 1)
		if (GetNamedObj("NO_InnerTown" + i).obj.player == 4) {
			GetSettlement("S_InnerTown" + i).SetGold(2000);
			GetSettlement("S_InnerTown" + i).SetFood(2000);
		}
}