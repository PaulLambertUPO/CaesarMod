while (1) {
	if (NO_Alexandria.obj.player == 1)
		if (NO_Memphis.obj.player == 1)
			if (NO_Pelusio.obj.player == 1)
				break;
	Sleep(1000);
}

ClearNotes();
RunConv("AugustusSpeech");
Sleep(1000);

PlayMovie(Translate("Movies/ENG/GreatBattles/4_Extro_Great_B_Egypt.avi"));

EndGame(1, false, Translate("You have managed to defeat Cleopatra and conquer Egypt!"));