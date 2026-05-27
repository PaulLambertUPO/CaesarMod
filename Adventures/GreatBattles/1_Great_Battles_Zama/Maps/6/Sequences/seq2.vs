DiplCeaseFire(3, 4, true);
DiplCeaseFire(4, 3, true);

BlockUserInput();
SetFog(false);

StartViewFollow(NO_RomanShip1);
Sleep(200);
WaitIdle(Q_RomanShips, -1);
Q_RomanShips.SetCommand("stand_position");
StopViewFollow();
View(NO_RomanShip1.obj.pos, false);

Sleep(2500);
SpawnGroup("Q_LandingGroup1").SetCommandOffset("move", AreaCenter("A_Landing1"));
Sleep(1000);
SpawnGroup("Q_LandingGroup2").SetCommandOffset("move", AreaCenter("A_Landing1"));
Sleep(1000);
SpawnGroup("Q_Scipio").SetCommand("move", AreaCenter("A_Landing2"));
Sleep(750);
SpawnGroup("Q_LandingGroup3").SetCommandOffset("move", AreaCenter("A_Landing3"));
Sleep(1000);
SpawnGroup("Q_LandingGroup4");
Q_LandingGroup1.SetCommand("attack", AreaCenter("A_Landing1"));
Q_LandingGroup2.SetCommand("attack", AreaCenter("A_Landing1"));
Q_LandingGroup3.SetCommand("attack", AreaCenter("A_Landing3"));
Q_LandingGroup4.SetCommand("attack", AreaCenter("A_Landing3"));

DiplCeaseFire(3, 4, false);
DiplCeaseFire(4, 3, false);

WaitEmptyQuery(Q_IntroEnemies, -1);
Q_RomanShips.SetCommand("idle");

NO_Scipio.SetCommand("move", AreaCenter("A_Landing2"));
SpawnGroup("Q_SupplyMules").SetCommand("follow", NO_Scipio);
Sleep(1000);
Q_LandingGroup.SetCommand("attach", NO_Scipio);
NO_Scipio.SetCommand("move", AreaCenter("A_Landing1"));

Sleep(2000);
SpawnGroup("Q_Scout").SetCommand("move", AreaCenter("A_Landing1") + Point(-100, 130));
WaitIdle(NO_Scout, -1);
RunConv("Intro");
_PlaceEx("WatchEye", 13025, 14210, 1);
_PlaceEx("WatchEye", 12271, 13812, 1);

NO_Scipio.SetCommand("leavearmy");
Q_LandingGroup.SetPlayer(2);
Q_LandingGroup.SetCommand("stand_position");
Q_SupplyMules.SetPlayer(2);
Q_SupplyMules.SetCommand("move", AreaCenter("A_Landing1") + Point(25, 25));

View(AreaCenter("A_Landing2"), false);
SetFog(true);
UnblockUserInput();

SetShortcutSel(1, 1, Q_Scipio.GetObjList());

GiveNote("Meet Masinissa");
GiveNote("Scipio must survive");

NO_Scout.SetCommand("approach", NO_RomanShip1);
NO_Scout.AddCommand(false, "boardship", NO_RomanShip1);
Sleep(7500);
Q_RomanShips.SetCommand("move", AreaCenter("A_Ocean"));

WaitQueryCountBetween(Intersect(Q_RomanShips, AreaObjs("A_Ocean", cUnit)), 1, -1, -1);
Q_RomanShips.Erase();

WaitQueryCountBetween(ClassPlayerAreaObjs(cUnit, 1, "A_Ambush"), 1, -1, -1);
SpawnGroup("Q_Ambush");