while (1) {
	if (BadGuys1.obj.player == 1)
		if (Final.IsEmpty()) {
			Sleep(5000);
			SpawnGroup("Ptolemy").SetCommand("move", AreaCenter("A_Defence"));
			WaitIdle(Ptolemy, 6000);
			RunConv("C_Conv8");
			Sleep(100);
			break;
		}
	Sleep(1000);
}

PlayMovie(Translate("Movies/ENG/GreatChallenges/3_Extro_Great_L_Egypt.avi"));

EndGame(1 , false , Translate("You have achieved a great victory over Rome!"));