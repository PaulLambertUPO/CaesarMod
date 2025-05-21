ObjList ships;
Ship sh;
int i;

for (i = 1; i <= 7; i += 1) {
	GetNamedObj("R_Ship" + i).obj.CmdDisable("unboardall");
	SpawnGroupInHolder("R_Army" + i, GetNamedObj("R_Ship" + i));
}

R_Army1.SetCommand("attach", R_Augustus);
R_Army2.SetCommand("attach", R_Hero1);
R_Army3.SetCommand("attach", R_Hero2);

Sleep(500);

for (i = 1; i <= 3; i += 1)
	SpawnGroupInHolder("E_YellowCrew" + i, GetNamedObj("E_YellowShip" + i));

for (i = 1; i <= 5; i += 1)
	SpawnGroupInHolder("E_GreenCrew" + i, GetNamedObj("E_GreenShip" + i));

RunConv("NavalBattle");

GiveNote("LoseCondition1");
GiveNote("WinCondition");
GiveNote("NavalBattleAdvice");

while (!E_YellowFleet.IsEmpty() && !E_GreenFleet.IsEmpty()) {
	if (!ClassPlayerAreaObjs("Unit", 1, "A_DropPlayer").IsEmpty())//just in case the player finds a way to unboard the units
		break;
	E_UnitedFleet.SetCommand("advance", R_Ship1.obj.pos);
	Sleep(5000);
}

R_Army.SetPlayer(1);
for (i = 1; i <= 7; i += 1)
	GetNamedObj("R_Ship" + i).obj.CmdEnable("unboardall");

SetShortcutSel(1, 1, R_Augustus.GetObjList());
SetShortcutSel(1, 2, R_Hero1.GetObjList());
SetShortcutSel(1, 3, R_Hero2.GetObjList());

RunConv("GoToPelusio");
GiveNote("PelusioAdvice");

Sleep(1000);

while (!E_UnitedFleet.IsEmpty()) {
	ships = E_UnitedFleet.GetObjList();
	ships.ClearDead();
	for (i = 0; i < ships.count; i += 1) {
		sh = ships[i].AsShip();
		if (sh.IsValid)
			if (sh.GetUnitsOnBoard().count <= 0)
				sh.Damage(sh.maxhealth);
			else if (sh.command != "unboardall")
				sh.SetCommand("unboardall", GetRandomPointInArea("A_DropAlexandria"));
	}
	Sleep(2000);
}

Sleep(2000);

if (!E_UnitedCrew.IsEmpty())
	E_UnitedCrew.SetCommand("enter", NO_Alexandria);