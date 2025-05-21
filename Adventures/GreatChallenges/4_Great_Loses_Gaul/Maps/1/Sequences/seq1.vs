WaitEnvIntBetween("/En_End", 1, 1, -1);

Sleep(1000);

SpawnGroup("R_CaesarArmy").SetCommand("attach", NO_Caesar);
Sleep(500);

BlockUserInput();

HideZoomMap();

StartViewFollow(NO_Caesar);
NO_Caesar.SetCommand("move", AreaCenter("A_CaesarRun"));
Sleep(10000);
StopViewFollow();

UnblockUserInput();

SpawnGroup("G_KeltillArmy").SetCommand("attach", NO_Keltill);
Sleep(1000);
RunConv("Victory");

ClearNotes();

PlayMovie(Translate("Movies/ENG/GreatChallenges/4_Extro_Great_L_Gaul.avi"));

EndGame(1, false, Translate("You have managed to defeat Julius Caesar and defend Gergovia!"));