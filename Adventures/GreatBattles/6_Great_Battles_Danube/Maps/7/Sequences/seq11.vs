point p_View;

WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 4, "A_Village1"), 15, 1000, -1);
_PlaceEx("WatchEye", 13250, 6700, 1);
_PlaceEx("WatchEye", 13250, 7000, 1);
Sleep(10000);
SpawnGroup("Q_AlliesFirstBlood").SetCommand("attack", AreaCenter("A_RightPos2"));
Sleep(3000);

BlockUserInput();

HideZoomMap();
p_View = ViewPos();
View(AreaCenter("A_Village1") + Point(300, 0), false);
Sleep(3000);
SpawnGroup("Q_VillageAllies1");
Q_VillageAllies1.AddToGroup("Q_AlliesFirstBlood");
Q_VillageAllies1.RemoveFromGroup("Q_VillageAllies1");
AttackArea(Q_AlliesFirstBlood, "A_RightPos2");
Sleep(7000);
View(p_View, false);

UnblockUserInput();

EnvWriteInt("/En_LocalResistenceSpotted", 1);
WaitEmptyQuery(ClassPlayerAreaObjs(cMilitary, 4, "A_Village1"), -1);
if (!Q_AlliesFirstBlood.IsEmpty())
	AttackArea(Q_AlliesFirstBlood, "A_Hideout");