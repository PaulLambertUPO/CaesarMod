SpawnGroupInHolder("I_WatchTowerDefence", "S_25");

WaitSettlementCapture("S_25", 1, -1);

EnvWriteInt("/TakenWatchTower", 1);

SpawnGroupInHolder("E_3", "S_25");

R_Chariot1.SetCommand("move", AreaCenter("A_Event3"));
Sleep(2500);
RunConv("Event3");

ExploreAll();

if (IsNoteActive("WatchTower"))
	RemoveNote("WatchTower");

if (EnvReadInt("/TakenFoodStorage") != 1)
	GiveNote("FoodStorage");

SpawnGroup("I_GaulArmy").SetCommand("attach", I_GaulHero);
I_GaulHero.obj.AsHero().SetAutocast(true);
Sleep(200);

I_GaulArmy.SetCommand("advance", NO_25.obj.pos);
I_GaulArmy.AddCommand(false, "capture", NO_25);

while (1) {
	SetFog(NO_25.obj.player != 1);
	Sleep(5000);
}