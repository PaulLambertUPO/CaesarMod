int i;

NO_SecondDruid.SetCommand("hold_position");
T_CampGuards.SetCommand("stand_position");

WaitQueryCountBetween(ClassPlayerAreaObjs("Unit", 1, "A_CampArea"), 1, 1000, -1);

SpawnGroup("T_CampTribunes");
RunAIHelper("GuardCamp", "guard area", "T_CampTribunes", "A_CampArea");

WaitEmptyQuery(T_CampTribunes, -1);

NO_SecondDruid.obj.SetPlayer(1);
NO_SecondDruid.obj.AsUnit().SetMessengerStatus(false);
NO_SecondDruid.obj.AsUnit().SetVisible(true);
Sleep(1000);

RunConv("SecondDruid");

EnvWriteInt("/En_DruidFound", 1);

if (IsNoteActive("RomanCamp"))
	RemoveNote("RomanCamp");

for (i = 11; i <= 17; i += 1)
	ExploreArea(1, "A_Expl" + i);

if (ShipYard.obj.player != 1)
	GiveNote("CaptureShip");

if (EnvReadInt("/En_LaraxFound") != 1)
	GiveNote("FindLarax");