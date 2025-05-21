DiplCeaseFire(1, 3, true);
DiplCeaseFire(3, 1, true);
DiplCeaseFire(1, 2, true);
DiplCeaseFire(2, 1, true);
DiplCeaseFire(2, 3, true);
DiplCeaseFire(3, 2, true);

DiplShareView(1, 3, true);
DiplShareView(3, 1, true);

DiplCeaseFire(4, 5, true);
DiplCeaseFire(5, 4, true);

DiplCeaseFire(1, 7, true);
DiplCeaseFire(7, 1, true);
DiplCeaseFire(2, 7, true);
DiplCeaseFire(7, 2, true);
DiplCeaseFire(3, 7, true);
DiplCeaseFire(7, 3, true);
DiplCeaseFire(4, 7, true);
DiplCeaseFire(7, 4, true);
DiplCeaseFire(5, 7, true);
DiplCeaseFire(7, 5, true);

DiplShareSupport(1, 7, true);
DiplShareSupport(7, 1, true);

DiplShareControl(1, 7, true);
DiplShareControl(7, 1, true);

EnvWriteInt("/En_NewMessenger", 0);
EnvWriteInt("/En_DownArea1", 1);
EnvWriteInt("/En_DownArea2", 1);
EnvWriteInt("/En_DownArea3", 1);
EnvWriteInt("/En_MidArea1", 1);
EnvWriteInt("/En_MidArea2", 1);
EnvWriteInt("/En_MidArea3", 1);
EnvWriteInt("/En_UpArea1", 1);
EnvWriteInt("/En_UpArea2", 1);
EnvWriteInt("/En_UpArea3", 1);

SpawnGroupInHolder("Q_UpGermanArchers", "S_UpOutpost");
SpawnGroupInHolder("Q_UpGermanInfantry", "S_UpOutpost");

SpawnGroupInHolder("Q_MidGermanArchers", "S_MidOutpost");
SpawnGroupInHolder("Q_MidGermanInfantry", "S_MidOutpost");

SpawnGroupInHolder("Q_DownGermanArchers", "S_DownOutpost");
SpawnGroupInHolder("Q_DownGermanInfantry", "S_DownOutpost");

SetShortcutSel(1, 1, Q_Hero.GetObjList());

GetSettlement("S_UnbreakableRomanTown").AllowCapture(false);
GetSettlement("S_DownOutpost").AllowCapture(false);
GetSettlement("S_MidOutpost").AllowCapture(false);
GetSettlement("S_UpOutpost").AllowCapture(false);

EnvWriteInt(1, "MaxMacemen", 10);
EnvWriteString(1, "Increase Mace production", "researched");

NO_Smith.obj.CmdDisable("Strenghten Stronghold Defences I");
NO_Smith.obj.CmdDisable("Strenghten Stronghold Defences II");

NO_Arena.obj.CmdDisable("hireheroT");
NO_Arena.obj.CmdDisable("Legendary Valkyries");

stonehenge_arminius.obj.CmdDisable("sacrifice");
stonehenge_arminius.obj.CmdDisable("gold_rain");
stonehenge_arminius.obj.CmdDisable("starvation");
stonehenge_arminius.obj.CmdDisable("earthquake");
stonehenge_arminius.obj.CmdDisable("teuton_horde");

Sleep(1000);

NO_Village3.SetCommand("tribute", NO_MainCamp);
NO_Village4.SetCommand("tribute", NO_MainCamp);

_PlaceEx("WatchEyeSmall", 2503, 9523, 1);
_PlaceEx("WatchEyeSmall", 3221, 10151, 1);
_PlaceEx("WatchEyeSmall", 2566, 11116, 1);
_PlaceEx("WatchEyeSmall", 3166, 11458, 1);
_PlaceEx("WatchEyeSmall", 3503, 11274, 1);
_PlaceEx("WatchEyeSmall", 3806, 11251, 1);
_PlaceEx("WatchEyeSmall", 4673, 12299, 1);
_PlaceEx("WatchEyeSmall", 5272, 12521, 1);
_PlaceEx("WatchEyeSmall", 6194, 11952, 1);
_PlaceEx("WatchEyeSmall", 9411, 11236, 1);
_PlaceEx("WatchEye", 12894, 12318, 1);
_PlaceEx("WatchEyeSmall", 2254, 7690, 1);
_PlaceEx("WatchEyeSmall", 3165, 7347, 1);
_PlaceEx("WatchEyeSmall", 4729, 5182, 1);
_PlaceEx("WatchEyeSmall", 5059, 4871, 1);
_PlaceEx("WatchEyeSmall", 5331, 4795, 1);
_PlaceEx("WatchEyeSmall", 5560, 4922, 1);
_PlaceEx("WatchEyeSmall", 5807, 5044, 1);
_PlaceEx("WatchEyeSmall", 8274, 6570, 1);
_PlaceEx("WatchEyeSmall", 10179, 5579, 1);
_PlaceEx("WatchEyeSmall", 11573, 5611, 1);
_PlaceEx("WatchEyeSmall", 9142, 11910, 1);
_PlaceEx("WatchEyeSmall", 12106, 5326, 1);
_PlaceEx("WatchEyeSmall", 12646, 5476, 1);
_PlaceEx("WatchEyeSmall", 12918, 5563, 1);
_PlaceEx("WatchEyeSmall", 421, 6724, 1);
_PlaceEx("WatchEyeSmall", 414, 5931, 1);
_PlaceEx("WatchEyeSmall", 1469, 5103, 1);
_PlaceEx("WatchEyeSmall", 1519, 4106, 1);
_PlaceEx("WatchEyeSmall", 2629, 2590, 1);
_PlaceEx("WatchEyeSmall", 3068, 2434, 1);
_PlaceEx("WatchEyeSmall", 4563, 3329, 1);
_PlaceEx("WatchEyeSmall", 4846, 3346, 1);
_PlaceEx("WatchEyeSmall", 5102, 3383, 1);
_PlaceEx("WatchEyeSmall", 5339, 3322, 1);
_PlaceEx("WatchEyeSmall", 7136, 3239, 1);
_PlaceEx("WatchEye", 9446, 6049, 1);
_PlaceEx("WatchEyeSmall", 7753, 3394, 1);
_PlaceEx("WatchEyeSmall", 8812, 2625, 1);
_PlaceEx("WatchEyeSmall", 9329, 3293, 1);
_PlaceEx("WatchEyeSmall", 3893, 9325, 1);
_PlaceEx("WatchEyeSmall", 3736, 8516, 1);
_PlaceEx("WatchEyeSmall", 5066, 8142, 1);
_PlaceEx("WatchEyeSmall", 6479, 7488, 1);
_PlaceEx("WatchEyeSmall", 7170, 7044, 1);
_PlaceEx("WatchEyeSmall", 7501, 6227, 1);
_PlaceEx("WatchEyeSmall", 6392, 2834, 1);
_PlaceEx("WatchEyeSmall", 2186, 10834, 1);