DiplCeaseFire(1, 2, true);
DiplCeaseFire(2, 1, true);
DiplShareSupport(1, 2, true);
DiplShareSupport(2, 1, true);
DiplShareView(1, 2, true);
DiplShareView(2, 1, true);

DiplCeaseFire(5, 4, true);
DiplCeaseFire(4, 5, true);
DiplShareSupport(5, 4, true);
DiplShareSupport(4, 5, true);
DiplShareView(5, 4, true);
DiplShareView(4, 5, true);

EnvWriteInt("/Ships", 0);
EnvWriteInt("/Caves", 0);
EnvWriteInt("/GlobalSpells", 0);
EnvWriteInt("/ImportantTown", 0);
EnvWriteInt("/CalgacusArmy", 0);
EnvWriteInt("/CalgacusSpawned", 0);

GetSettlement("S_Sett1").Research("ChooseImperialRome");
NO_0.SetCommand("tribute", NO_1);
NO_Blacksmith1.obj.CmdDisable("Strenghten Stronghold Defences I");
NO_Blacksmith1.obj.CmdDisable("Strenghten Stronghold Defences II");
NO_Blacksmith2.obj.CmdDisable("Strenghten Stronghold Defences I");
NO_Blacksmith2.obj.CmdDisable("Strenghten Stronghold Defences II");

RunConv("HelloAgricola");

GiveNote("WinCondition");
GiveNote("LoseCondition1");
GiveNote("LoseCondition2");
GiveNote("SenatorArmy");
GiveNote("B_Chieftains");

Sleep(500);

Senator.SetCommand("hold_position");
SetShortcutSel(1, 1, Agricola.GetObjList());
T_S_Sett1.SetCommand("attach", Agricola);
T_S_Sett1.RemoveFromAllGroups();

RunSequence("SpawnGroups");