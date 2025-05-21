WaitEmptyQuery(LastLegion, -1);
WaitSettlementCapture("S_RomeTown", 1, -1);

RunConv("WinTalk");

ClearNotes();

PlayMovie(Translate("Movies/ENG/GreatChallenges/6_Extro_Great_L_Boudicca.avi"));

EndGame(1, false, Translate("You have defeated the Roman invaders!"));