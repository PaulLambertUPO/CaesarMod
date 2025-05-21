ObjList ol;
int i;

IceniTown.obj.AsBuilding().Research("Britain Swords");
IceniTown.obj.AsBuilding().Research("Britain Fights");
IceniTown.obj.AsBuilding().Research("Britain chamber");

SetShortcutSel(1, 1, Natasha.GetObjList());
SetShortcutSel(1, 2, TalkDruid.GetObjList());

for (i = 1; i <= 11; i += 1)
	ExploreArea(1, "A_Explore" + i);

stonehenge_iceni.obj.CmdDisable("sacrifice");
stonehenge_iceni.obj.CmdDisable("gold_rain");
stonehenge_iceni.obj.CmdDisable("starvation");
stonehenge_iceni.obj.CmdDisable("teuton_horde");

BritVillage1.SetCommand("tribute", IceniTown);
BritVillage2.SetCommand("tribute", IceniTown);

GetSettlement("S_RomeTown").Research("ChooseImperialRome");

NO_Lleldoryn.obj.SetCommand("hold_position");
DungeonDruids.SetCommand("hold_position");
RuinDruids.SetCommand("hold_position");
GhoulDruid.SetCommand("hold_position");

GreenGuards.SetCommand("stand_position");

GreenArmy.SetCommand("attach", GreenHero);
GreenHero.obj.AsHero().SetAutocast(true);

LastLegion.SetCommand("attach", BrutalRomeHero);
BrutalRomeHero.obj.AsHero().SetAutocast(true);

for (i = 1; i <= 4; i += 1) {
	Group("RomanPatrol" + i).SetCommand("attach", GetNamedObj("PatrolHero" + i));
	GetNamedObj("PatrolHero" + i).obj.AsHero().SetFormation("Block");
	GetNamedObj("PatrolHero" + i).obj.AsHero().SetAutocast(true);
}

ol = DungeonHeroes.GetObjList();
for (i = 0; i < DungeonHeroes.count; i += 1)
	ol[i].AsHero().SetAutocast(true);

Sleep(3000);

RunAIHelper("Guard_Trinovantes", "guard", "GreenArmy", "S_GreenTown");
RunAIHelper("Guard_Camulodunum", "guard", "LastLegion", "S_RomeTown");

for (i = 1; i <= 4; i += 1)
	GetNamedObj("PatrolHero" + i).SetCommand("patrol", AreaCenter("A_Patrol" + i));

for (i = 1; i <= 5; i += 1)
	RunAIHelper("ChariotsGuard" + i, "guard area", "RomanChariots" + i, "A_ChariotsGuard" + i);