while (1) {
	if (NO_GaulCentral.obj.player == 1)
		if (NO_GaulOuter.obj.player == 1)
			break;
	Sleep(5000);
}

ClearNotes();

RunConv("Victory");

PlayMovie(Translate("Movies/ENG/GreatBattles/3_Extro_Great_B_Alesia.avi"));

EndGame(1, false, Translate("Alesia is yours!"));