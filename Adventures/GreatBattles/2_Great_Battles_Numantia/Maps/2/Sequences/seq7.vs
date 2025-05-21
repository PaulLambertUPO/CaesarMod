WaitEmptyQuery(I_NumantiaDefence, -1);
WaitSettlementCapture("S_40", 1, -1);

ClearNotes();
RunConv("Victory");

PlayMovie(Translate("Movies/ENG/GreatBattles/2_Extro_Great_B_Numantia.avi"));

EndGame(1, false, Translate("You have captured Numantia!"));