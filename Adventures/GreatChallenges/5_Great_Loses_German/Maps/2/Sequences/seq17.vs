int i;

while (1) {
	Sleep(500);
	for (i = 1; i <= 5; i += 1)
		if (GetNamedObj("NO_Village" + i).obj.player == 1)
			GetNamedObj("NO_Village" + i).obj.SetPlayer(7);
}