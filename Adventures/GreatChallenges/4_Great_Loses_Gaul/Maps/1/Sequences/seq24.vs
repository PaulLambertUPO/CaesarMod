Sleep(100);

BlockUserInput();

G_Vercingetorix.SetCommand("stand_position");
R_Intro.SetCommandOffset("move", AreaCenter("A_Intro"));
Sleep(3500);
RunConv("Intro1");
SpawnGroup("G_Intro");
Sleep(500);
Union(G_Vercingetorix, G_Intro).SetCommand("attack", AreaCenter("A_Intro"));

WaitEmptyQuery(R_Intro, -1);
G_Intro.SetCommand("attach", NO_Vercingetorix);

SpawnNamed("NO_IntroChieftain").SetCommand("move", NO_Vercingetorix.obj.posRH + Point(120, -120));
Sleep(3000);
RunConv("Intro2");

GiveNote("Protect the chieftains.");
GiveNote("Vercingetorix must survive.");
GiveNote("Save Gergovia.");

UnblockUserInput();

NO_IntroChieftain.SetCommand("move", AreaCenter("A_IntroChieftain"));
NO_IntroChieftain.obj.AsUnit().SetSpeedFactor(125);
WaitUnitsInArea(NO_IntroChieftain, "A_IntroChieftain", -1);
NO_IntroChieftain.Erase();

SpawnGroupInHolder("G_Luthal", "S_Gergovia").SetCommand("attack", AreaCenter("A_Luthal"));
SpawnGroupInHolder("G_LuthalArmy", "S_Gergovia").SetCommand("attach", NO_Luthal);

SetShortcutSel(1, 2, G_Luthal.GetObjList());