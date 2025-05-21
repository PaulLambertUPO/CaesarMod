DiplCeaseFire(1, 2, true);
DiplCeaseFire(2, 1, true);
DiplCeaseFire(1, 3, true);
DiplCeaseFire(3, 1, true);
DiplCeaseFire(2, 3, true);
DiplCeaseFire(3, 2, true);

DiplShareSupport(1, 2, true);
DiplShareSupport(2, 1, true);

DiplShareView(1, 2, true);
DiplShareView(2, 1, true);
DiplShareView(1, 3, true);
DiplShareView(3, 1, true);

ETemple.obj.CmdDisable("Chariot of Osiris");
EMarket.obj.CmdDisable("BuySlaves");
CMarket.obj.CmdDisable("Mercenary pact");
CMarket.obj.CmdDisable("Mercenary heal");
CMarket.obj.CmdDisable("Hire foreign mercenaries");

EShrine.obj.CmdDisable("sacrifice");
EShrine.obj.CmdDisable("gold_rain");
EShrine.obj.CmdDisable("starvation");
EShrine.obj.CmdDisable("earthquake");
EShrine.obj.CmdDisable("teuton_horde");

SetShortcutSel(1, 1, GoodHero.GetObjList());
SetShortcutSel(1, 2, GoodHero2.GetObjList());

AxeThrowers.SetCommand("attach", GoodHero);
NileGuardians.SetCommand("attach", GoodHero2);

SpawnGroup("Defenders_Left");
SpawnGroup("Defenders_Right");

GetSettlement("S_BadGuys2").AllowCapture(false);
GetSettlement("S_BadGuys1").AllowCapture(false);

EnvWriteInt("/En_Direction", 0);

Village1.SetCommand("tribute", Town);
Village2.SetCommand("tribute", Town);
Village3.SetCommand("tribute", Town);
Village4.SetCommand("tribute", Town);

RunAIHelper("GuardArea_Left", "guard area", "Defenders_Left", "A_AdvanceB3");
RunAIHelper("GuardArea_Right", "guard area", "Defenders_Right", "A_AdvanceA3");

RunConv("C_Conv1");
GiveNote("Herakleopolis Magna must not fall.");
GiveNote("Support priests.");

NO_HighPriest.SetCommand("enter", Town);
Sleep(3000);
NO_HighPriest.Erase();
Sleep(1000);

RunConv("C_Conv2");
Sleep(500);
GiveNote("Altar of the gods.");

Sleep(10000);

//Teleports
_PlaceEx("WatchEye", 6511, 10554, 1);
_PlaceEx("WatchEye", 8004, 10331, 1);
_PlaceEx("WatchEye", 9549, 10513, 1);

//GodsGift
_PlaceEx("WatchEye", 7600, 5870, 1);
_PlaceEx("WatchEye", 7800, 5870, 1);
_PlaceEx("WatchEye", 8000, 5870, 1);

//A_AdvanceA
_PlaceEx("WatchEye", 10571, 7040, 1);
_PlaceEx("WatchEye", 12429, 8134, 1);
_PlaceEx("WatchEye", 13565, 9615, 1);
_PlaceEx("WatchEye", 13943, 12484, 1);

//A_AdvanceB
_PlaceEx("WatchEye", 5138, 6923, 1);
_PlaceEx("WatchEye", 3847, 7813, 1);
_PlaceEx("WatchEye", 2960, 9423, 1);
_PlaceEx("WatchEye", 3810, 10920, 1);