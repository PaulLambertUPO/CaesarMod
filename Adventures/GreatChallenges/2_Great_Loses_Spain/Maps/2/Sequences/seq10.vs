ObjList ol;
int i;

DiplCeaseFire(1, 2, true);
DiplCeaseFire(2, 1, true);

DiplShareSupport(1, 2, true);
DiplShareSupport(2, 1, true);

ExploreArea(1, "A_RomanTown");

GiveNote("CaptureRomans");
GiveNote("LoseTown");
GiveNote("LoseViriato");

EnvWriteInt("/En_DruidFound", 0);
EnvWriteInt("/En_LaraxFound", 0);

SetShortcutSel(1, 1, NO_Viriato.GetObjList());

NO_Catriona.SetCommand("hold_position");

ol = T_StartArmy.GetObjList();
for (i = 0; i < ol.count; i += 1)
	ol[i].AsUnit().AddItem("Veteran Guild");
ol.SetCommand("attach", NO_Viriato);

RunConv("Start");

for (i = 1; i <= 2; i += 1)
	GetNamedObj("Village" + i).SetCommand("tribute", NO_RomanTown);
for (i = 6; i <= 8; i += 1)
	GetNamedObj("Village" + i).SetCommand("tribute", NO_MainTown);
Village3.SetCommand("tribute", Village4);
Village4.SetCommand("tribute", Village6);
Village5.SetCommand("tribute", Village6);

RunSequence("RomanArmyAtt");
RunSequence("SpawnArmies");