int townhalls, i;

while (townhalls < 8) {
	Sleep(5000);
	townhalls = 0;
	if (NO_OuterTown.obj.player != 4)
		townhalls += 1;
	for (i = 1; i < 8; i += 1)
		if (GetNamedObj("NO_InnerTown" + i).obj.player != 4)
			townhalls += 1;
}

Sleep(5000);

RunConv("C_Conv6");
ClearNotes();

PlayMovie(Translate("Movies/ENG/GreatChallenges/1_Extro_Great_L_Rome.avi"));

EndGame(1, false, Translate("You have captured Rome, the great city!"));