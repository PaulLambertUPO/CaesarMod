bool conquered = false;
while (!conquered) {
	Sleep(1000);
	if (NO_OuterTown.obj.player != 4)
		conquered = true;
	else if (NO_InnerTown1.obj.player != 4)
		conquered = true;
	else if (NO_InnerTown2.obj.player != 4)
		conquered = true;
	else if (NO_InnerTown3.obj.player != 4)
		conquered = true;
	else if (NO_InnerTown4.obj.player != 4)
		conquered = true;
	else if (NO_InnerTown5.obj.player != 4)
		conquered = true;
	else if (NO_InnerTown6.obj.player != 4)
		conquered = true;
	else if (NO_InnerTown7.obj.player != 4)
		conquered = true;
	if (conquered) {
		SpawnGroup("Q_Crier").SetCommand("attack", AreaCenter("A_ThirdPatrol2"));
		Sleep(2000);
		RunConv("C_Conv5");
		GiveNote("Roman reinforcements.");
	}
}