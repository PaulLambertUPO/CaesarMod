ItemHolder holder;
Unit u;
point pos, pt1, pt2;
int i, j;
bool talked = false;

pos = GhoulTown.obj.pos;

GetSettlement("S_GhoulTown").AllowCapture(false);
GetSettlement("GhostSett1").AllowCapture(false);
GetSettlement("GhostSett2").AllowCapture(false);

EnvWriteInt(GetSettlement("S_GhoulTown"), "no_villagers", 1);
EnvWriteInt(GetSettlement("GhostSett1"), "no_villagers", 1);
EnvWriteInt(GetSettlement("GhostSett2"), "no_villagers", 1);

for (i = 1; i <= 4; i += 1)
	GetNamedObj("G_Gate" + i).obj.SetCommand("open_permanent");

holder = HoldGhoulTown.obj.AsItemHolder();

while (!holder.HasItem("Bloodstone")) {
	if (!talked)
		if (WaitUnitsInArea(Natasha, "A_GhoulTalk", 1000)) {
			RunConv("GhoulTalk");
			talked = true;
		}
	for (i = 50 - Group("Ghouls").count; i > 0; i -= 1) {
		u = Place(cGGhostUnlimited, pos, 2);
		u.AddToGroup("Ghouls");
		pt1.Set(0, 1600);
		pt1.Rot(rand(360));
		pt2 = pt1 + pos;
		u.SetCommand("advance", pt2);
		for (j = 0; j < 4; j += 1) {
			pt1.Rot(90);
			pt2 = pt1 + pos;
			u.AddCommand(false, "patrol", pt2);
		}
		Sleep(250);
	}
	ClassPlayerAreaObjs(cSentry, 2, "A_Explore13").Erase();
	Sleep(1000);
}

if (IsNoteActive("Bloodstone"))
	RemoveNote("Bloodstone");

RunConv("LiftedCurse");
GhoulDruid.obj.AsUnit().SetMessengerStatus(false);
GhoulDruid.SetPlayer(1);

Group("Ghouls").Damage(1000);

GhoulTown.SetPlayer(1);
GetSettlement("S_GhoulTown").AddToMaxPopulation(99);
GetSettlement("S_GhoulTown").AddToPopulation(99);
GetSettlement("S_GhoulTown").AllowCapture(true);

GhostVillage1.SetPlayer(1);
GhostVillage1.SetCommand("tribute", GhoulTown);
GetSettlement("GhostSett1").AddToMaxPopulation(59);
GetSettlement("GhostSett1").AddToPopulation(59);
GetSettlement("GhostSett1").AllowCapture(true);

GhostVillage2.SetPlayer(1);
GhostVillage2.SetCommand("tribute", GhoulTown);
GetSettlement("GhostSett2").AddToMaxPopulation(59);
GetSettlement("GhostSett2").AddToPopulation(59);
GetSettlement("GhostSett2").AllowCapture(true);

EnvWriteInt(GetSettlement("S_GhoulTown"), "no_villagers", 0);
EnvWriteInt(GetSettlement("GhostSett1"), "no_villagers", 0);
EnvWriteInt(GetSettlement("GhostSett2"), "no_villagers", 0);

for (i = 1; i <= 4; i += 1)
	GetNamedObj("G_Gate" + i).obj.SetCommand("idle");