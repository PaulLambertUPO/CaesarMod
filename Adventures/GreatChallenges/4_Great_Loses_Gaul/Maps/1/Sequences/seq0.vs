ObjList ol;
Unit u;
int i;

DiplCeaseFire(1, 2, true);
DiplCeaseFire(2, 1, true);

DiplShareView(1, 2, true);
DiplShareView(2, 1, true);

DiplShareSupport(1, 2, true);
DiplShareSupport(2, 1, true);

EnvWriteInt("/En_MaxWaves", 16 + GetDifficulty() * 4);
EnvWriteInt("/En_CurrentWave", 0);
EnvWriteInt("/En_FinalWave", 0);
EnvWriteInt("/En_End", 0);
for (i = 1; i <= 8; i += 1)
	EnvWriteInt("/En_AttackCorridor" + i, 0);

_PlaceEx("WatchEye", 6224, 712, 1);
_PlaceEx("WatchEye", 4817, 3585, 1);
_PlaceEx("WatchEye", 4903, 6119, 1);
_PlaceEx("WatchEye", 5963, 8277, 1);
_PlaceEx("WatchEye", 7692, 8665, 1);
_PlaceEx("WatchEye", 10000, 9090, 1);
_PlaceEx("WatchEye", 10987, 12929, 1);
_PlaceEx("WatchEye", 13447, 12112, 1);
_PlaceEx("WatchEye", 15171, 12958, 1);

SetShortcutSel(1, 1, G_Vercingetorix.GetObjList());

NO_Doomed.obj.AsHero().SetAutocast(true);

G_GergoviaDefenders.SetCommand("stand_position");
G_CorridorDefenders.SetCommand("stand_position");

ol = Union(G_Chieftains, G_GergoviaDefenders).GetObjList();
for (i = 0; i < ol.count; i += 1) {
	u = ol[i].AsUnit();
	if (u.IsValid) {
		u.AddItem("Bear teeth amulet");
		u.AddItem("Belt of might");
		u.AddItem("Herb amulet of luck");
	}
}

NO_Gergovia.obj.AsBuilding().Research("Gaul Horseman");
NO_Gergovia.obj.AsBuilding().Research("Gaul Exceptional Horseshoes");

NO_Village1.SetCommand("tribute", NO_Gergovia);
for (i = 2; i <= 5; i += 1)
	GetNamedObj("NO_Village" + i).SetCommand("tribute", NO_Village1);

NO_Arena.obj.CmdDisable("Legendary Heroes");
NO_Arena.obj.CmdDisable("Hire Keltill");
NO_Arena.obj.CmdDisable("Hire Larax");

gergovia_stonehenge.obj.CmdDisable("sacrifice");
gergovia_stonehenge.obj.CmdDisable("gold_rain");
gergovia_stonehenge.obj.CmdDisable("starvation");
gergovia_stonehenge.obj.CmdDisable("earthquake");
gergovia_stonehenge.obj.CmdDisable("teuton_horde");