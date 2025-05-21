WaitSettlementCapture("S_16", 1, -1);

SpawnGroupInHolder("E_2", "S_16");

R_Hero.SetCommand("move", AreaCenter("A_Event2"));
Sleep(3500);
RunConv("Event2");

if (EnvReadInt("/TakenWatchTower") != 1) {
	GiveNote("WatchTower");
	ExploreArea(1, "A_Explore2");
}