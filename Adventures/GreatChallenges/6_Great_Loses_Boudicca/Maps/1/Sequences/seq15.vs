int i;

while (RomeTown.obj.player == 5) {
	for (i = 1; i <= 6; i += 1)
		if (GetNamedObj("RomanOutpost" + i).obj.player == 5)
			GetNamedObj("RomanOutpost" + i).SetCommand("tribute", RomeTown);
	for (i = 1; i <= 5; i += 1)
		if (GetNamedObj("RomeVillage" + i).obj.player == 5)
			GetNamedObj("RomeVillage" + i).SetCommand("tribute", RomeTown);
	if (BritVillage2.obj.player == 5)
		BritVillage2.SetCommand("tribute", RomeTown);
	Sleep(10000);
}