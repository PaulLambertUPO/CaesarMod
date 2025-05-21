int p;

SpawnGroupInHolder("I_FoodStorageDefence", "S_27").SetCommand("attach", I_FoodStorageHero);
I_FoodStorageHero.obj.AsHero().SetAutocast(true);

WaitSettlementCapture("S_27", 1, -1);

EnvWriteInt("/TakenFoodStorage", 1);

SpawnGroupInHolder("E_4", "S_27");

R_Chariot2.SetCommand("move", AreaCenter("A_Event4"));
Sleep(2500);
RunConv("Event4");

if (IsNoteActive("FoodStorage"))
	RemoveNote("FoodStorage");

if (EnvReadInt("/TakenGuardTower") != 1)
	GiveNote("GuardTower");

while (1) {
	p = NO_27.obj.player;
	NO_29.obj.SetPlayer(p);
	NO_31.obj.SetPlayer(p);
	NO_32.obj.SetPlayer(p);
	NO_34.obj.SetPlayer(p);
	NO_35.obj.SetPlayer(p);
	Sleep(5000);
}