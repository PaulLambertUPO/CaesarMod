WaitEnvIntBetween("/CalgacusSpawned", 1, 1, -1);
WaitEmptyQuery(T_CalgacusArmy, -1);

ClearNotes();

RunConv("Victory");

PlayMovie(Translate("Movies/ENG/GreatBattles/5_Extro_Great_B_Britain.avi"));

EndGame(1, false, Translate("You have conquered Britain for Rome!"));