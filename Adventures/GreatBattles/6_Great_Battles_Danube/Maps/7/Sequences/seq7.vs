WaitEnvIntBetween("/En_TotalWaves", (8 + 2 * GetDifficulty()), 100, -1);

Sleep(10000);

WaitEmptyQuery(Q_ToWin, 720000);

RunConv("C_Conv4");
_PlaceEx("WatchEye", 1914, 3030, 1);

RemoveNote("Defend Aquileia");
GiveNote("Final blow");

WaitEmptyQuery(Q_GermanCampGuards, -1);

ClearNotes();

PlayMovie(Translate("Movies/ENG/GreatBattles/6_Extro_Great_B_Danube.avi"));

EndGame(1, false, Translate("The German threat is no more!"));