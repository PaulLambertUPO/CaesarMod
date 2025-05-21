ObjList assassins;
int i;

Sleep(1500);
Q_HannibalForces1.SetCommandOffset("attack", AreaCenter("A_IntroDest1"));
Q_HannibalForces2.SetCommandOffset("attack", AreaCenter("A_IntroDest2"));
Q_HannibalForces3.SetCommandOffset("attack", AreaCenter("A_IntroDest3"));
Sleep(30000);
SpawnGroup("Q_Assassins");
SpawnGroup("Q_Adviser");
SpawnGroup("Q_Elephants");
SpawnGroup("Q_Hero1");
Q_Assassins.SetCommand("attach", NO_Hannibal);
assassins = Q_Assassins.GetObjList();
for (i = 0; i < assassins.count; i += 1)
	assassins[i].AsUnit().AddItem("God's Gift");
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

SetShortcutSel(1, 1, Q_Hero1.GetObjList());