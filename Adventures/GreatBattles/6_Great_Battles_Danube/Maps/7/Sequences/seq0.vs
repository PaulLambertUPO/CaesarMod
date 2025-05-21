ObjList valkyries;
int i;

DiplCeaseFire(1, 2, true);
DiplCeaseFire(2, 1, true);
DiplCeaseFire(1, 3, true);
DiplCeaseFire(3, 1, true);
DiplCeaseFire(2, 3, true);
DiplCeaseFire(3, 2, true);

EnvWriteInt("/En_LocalResistenceSpotted", 0);
EnvWriteInt("/En_ArchersAlone", 0);
EnvWriteInt("/En_SendChasers", 0);

SpawnGroupInHolder("Q_CityGuard", "S_Town");

Q_Praetorians.SetCommand("attach", NO_Marcus);
for (i = 1; i < 4; i += 1)
	Group("Q_RomanPatrol" + i).SetCommand("patrol", AreaCenter("A_Patrol" + i));

valkyries = Q_Valkyries.GetObjList();
for (i = 0; i < valkyries.count; i += 1) {
	valkyries[i].AddItem("Feather amulet");
	valkyries[i].AddItem("King's Belt");
	valkyries[i].AddItem("Golden Ankh");
	valkyries[i].AddItem("Fur gloves of health");
}

RunAIHelper("DefendingGermanCamp", "guard area", "Q_GermanCampGuards", "A_GermanCamp");

Q_MiddleDef1.SetCommand("stand_position");
Q_MiddleDef2.SetCommand("stand_position");
Q_LeftDef1.SetCommand("stand_position");
Q_LeftDef2.SetCommand("stand_position");

NO_Subquest.SetCommand("hold_position");

_PlaceEx("WatchEye", 12862, 6727, 1);
_PlaceEx("WatchEye", 13250, 6700, 1);
_PlaceEx("WatchEye", 13250, 7000, 1);
_PlaceEx("WatchEye", 14317, 12888, 1);
_PlaceEx("WatchEye", 9202, 13090, 1);
_PlaceEx("WatchEye", 7484, 7966, 1);
_PlaceEx("WatchEye", 872, 10148, 1);
_PlaceEx("WatchEye", 7417, 15258, 1);

SetShortcutSel(1, 1, Q_Marcus.GetObjList());
SetShortcutSel(1, 2, Q_Hero1.GetObjList());
SetShortcutSel(1, 3, Q_Hero2.GetObjList());
SetShortcutSel(1, 4, Q_RightDef1.GetObjList());

for (i = 2; i <= 6; i+= 2)
	GetNamedObj("NO_Village" + i).SetCommand("tribute", NO_Village7);

GetSettlement("S_Town").Research("ChooseImperialRome");

danube_stonehenge.obj.CmdDisable("sacrifice");
danube_stonehenge.obj.CmdDisable("gold_rain");
danube_stonehenge.obj.CmdDisable("starvation");
danube_stonehenge.obj.CmdDisable("earthquake");
danube_stonehenge.obj.CmdDisable("teuton_horde");