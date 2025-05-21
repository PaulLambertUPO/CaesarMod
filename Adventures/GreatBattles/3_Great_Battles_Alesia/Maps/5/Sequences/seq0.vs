int i;

DiplCeaseFire(1, 2, true);
DiplCeaseFire(2, 1, true);
DiplShareView(1, 2, true);
DiplShareView(2, 1, true);

DiplCeaseFire(1, 7, true);
DiplCeaseFire(7, 1, true);
DiplShareView(1, 7, true);
DiplShareView(7, 1, true);

DiplCeaseFire(4, 5, true);
DiplCeaseFire(5, 4, true);
DiplShareView(4, 5, true);
DiplShareView(5, 4, true);

EnvWriteInt("/En_IntroEnds", 0);
EnvWriteInt("/En_AllWavesGone", 0);

GetSettlement("S_FortificationPoint1").Research("ChooseRepublicanRome");
GetSettlement("S_FortificationPoint2").Research("ChooseImperialRome");

NO_FortificationPoint1.obj.AsBuilding().Research("RGladiator Shows");

SetShortcutSel(1, 1, Q_Caesar.GetObjList());
SetShortcutSel(1, 2, Q_Hero1.GetObjList());
SetShortcutSel(1, 3, Q_Hero2.GetObjList());

NO_Caesar.obj.AsHero().SetSkill(hsConcealment, 0);
NO_Vercingetorix.obj.AsHero().SetAutocast(true);

for (i = 1; i <= 4; i += 1) {
	Group("Q_RomanPatrol" + i).SetCommand("patrol", AreaCenter("A_RomanPatrol" + i));
	SpawnGroupInHolder("Q_ReinforcementsPoint" + i, "S_FortificationPoint" + i);
}

Q_Standing.SetCommand("stand_position");

Q_GPatrolEast.SetCommand("patrol", AreaCenter("A_PatrolEast"));
Q_GPatrolWest.SetCommand("patrol", AreaCenter("A_PatrolWest"));
SpawnGroupInHolder("Q_InnerGTownhallDef1", "S_GaulOuter");
SpawnGroupInHolder("Q_InnerGTownhallDef2", "S_GaulCentral");