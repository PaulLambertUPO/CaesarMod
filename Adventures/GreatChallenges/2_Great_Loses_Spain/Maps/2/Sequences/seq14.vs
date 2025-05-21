int i;

WaitSettlementCapture("S_OutpostDruid", 1, -1);

SpawnNamed("NO_FirstDruid").SetCommand("move", AreaCenter("A_Point1"));
NO_FirstDruid.obj.AsUnit().SetVisible(true);
Sleep(4000);

RunConv("FirstDruid");

for (i = 1; i <= 10; i += 1)
	ExploreArea(1, "A_Expl" + i);

if (EnvReadInt("/En_DruidFound") != 1)
	GiveNote("RomanCamp");

if (IsNoteActive("Clue"))
	RemoveNote("Clue");

NO_FirstDruid.SetPlayer(1);