int i;

DiplCeaseFire(8, 1, true);
DiplCeaseFire(1, 8, true);
DiplCeaseFire(4, 7, true);
DiplCeaseFire(7, 4, true);
DiplCeaseFire(4, 8, true);
DiplCeaseFire(8, 4, true);
DiplCeaseFire(7, 8, true);
DiplCeaseFire(8, 7, true);

Sleep(800);

Q_Standing.SetCommand("stand_position");

SetShortcutSel(1, 2, Q_Hero2.GetObjList());
SetShortcutSel(1, 3, Q_Hero3.GetObjList());
SetShortcutSel(1, 4, Q_Hero4.GetObjList());

GetSettlement("S_Ostia").Research("ChooseRepublicanRome");
GetSettlement("S_TraitorTown").Research("ChooseRepublicanRome");
GetSettlement("S_OuterTown").Research("ChooseRepublicanRome");
for (i = 1; i <= 7; i += 1)
	GetSettlement("S_InnerTown" + i).Research("ChooseRepublicanRome");

EnvWriteInt(GetSettlement("S_OuterTown"), "SentriesLevel", 50);

SpawnGroupInHolder("Q_OstiaGuard", "S_Ostia");
SpawnGroupInHolder("Q_FrontGuard1", "S_OuterTown");
SpawnGroupInHolder("Q_FrontGuard2", "S_OuterTown");
SpawnGroupInHolder("Q_OuterRomeForce", "S_OuterTown");
for (i = 1; i <= 7; i += 1)
	SpawnGroupInHolder("Q_InnerRomeForce" + i, "S_InnerTown" + i);

for (i = 1; i <= 5; i += 1) {
	Group("Q_PatrolingForce" + i).SetCommand("attach", GetNamedObj("NO_PatrolingHero" + i));
	GetNamedObj("NO_PatrolingHero" + i).obj.AsHero().SetAutocast(true);
}

Sleep(2500);

NO_PatrolingHero5.obj.AsHero().SetFormation("Line");
NO_PatrolingHero5.SetCommand("patrol", AreaCenter("A_InitialPatrol"));

Ostia_Arena.obj.CmdDisable("Transition to Empire");
Ostia_Arena.obj.CmdDisable("Hire Caesar");
Traitor_Arena.obj.CmdDisable("Transition to Empire");
Traitor_Arena.obj.CmdDisable("Hire Caesar");