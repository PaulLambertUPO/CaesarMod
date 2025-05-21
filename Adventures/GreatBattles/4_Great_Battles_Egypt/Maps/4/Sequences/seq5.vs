while (1) {
	if (NO_Pelusio.obj.player != 1)
		if (NO_Alexandria.obj.player != 1)
			if (NO_Memphis.obj.player != 1)
				break;
	Sleep(1000);
}

ClearNotes();
EndGame(1, true, Translate("You have lost all major Egyptian cities."));