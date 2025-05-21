int i;

while (GreenTown.obj.player == 3) {
	for (i = 1; i <= 4; i += 1)
		if (GetNamedObj("BritVillage" + i).obj.player == 3)
			GetNamedObj("BritVillage" + i).SetCommand("tribute", GreenTown);
	Sleep(10000);
}