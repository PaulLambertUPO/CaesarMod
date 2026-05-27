ObjList assassins;
int i;

Sleep(1500);

Q_HannibalForces1.SetCommandOffset("attack", AreaCenter("A_IntroDest1"));
Q_HannibalForces2.SetCommandOffset("attack", AreaCenter("A_IntroDest2"));
Q_HannibalForces3.SetCommandOffset("attack", AreaCenter("A_IntroDest3"));

Sleep(30000);

SpawnGroup("Q_Hero1");
SpawnGroup("Q_Adviser");
SpawnGroup("Q_Elephants");
assassins = SpawnGroup("Q_Assassins");
for (i = assassins.count - 1; i >= 0; i -= 1) {
	assassins[i].SetCommand("attach", NO_Hannibal);
	assassins[i].AddItem("God's Gift");
}
NO_Hannibal.SetCommand("attack", AreaCenter("A_HeroDest"));
Q_Elephants.SetCommand("attack", AreaCenter("A_ElephantDest"));
Q_Adviser.SetCommand("attack", AreaCenter("A_HeroDest") + Point(100, 100));

Sleep(10000);

RunConv("C_Conv2");

GiveNote("Capture Rome.");
GiveNote("Hannibal must survive.");
GiveNote("Capture Ostia.");
GiveNote("Roman allies.");

Q_Adviser.SetCommand("attach", NO_Hero2);
ClassPlayerObjs(cWagon, 1).SetCommand("follow", NO_Hannibal);

SetShortcutSel(1, 1, Q_Hero1.GetObjList());