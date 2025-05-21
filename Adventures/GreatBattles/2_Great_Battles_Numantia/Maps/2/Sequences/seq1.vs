DiplCeaseFire(1, 3, true);
DiplCeaseFire(3, 1, true);

DiplShareView(1, 3, true);
DiplShareView(3, 1, true);

EnvWriteInt("/TakenWatchTower", 0);
EnvWriteInt("/TakenFoodStorage", 0);
EnvWriteInt("/TakenGuardTower", 0);

RunConv("Begin");

GiveNote("WinCondition");
GiveNote("LoseCondition");
GiveNote("FortsAdvice");

SetShortcutSel(1, 1, R_Scipio.GetObjList());
SetShortcutSel(1, 2, R_Cornelius.GetObjList());

ExploreArea(1, "A_Explore1");

Sleep(100);
R_Army1.SetCommand("attach", R_Scipio);
R_Mule1.SetCommand("follow", R_Scipio);
R_Army2.SetCommand("attach", R_Cornelius);
R_Mule2.SetCommand("follow", R_Cornelius);

iberian_stonehenge.obj.CmdDisable("sacrifice");
iberian_stonehenge.obj.CmdDisable("teuton_horde");