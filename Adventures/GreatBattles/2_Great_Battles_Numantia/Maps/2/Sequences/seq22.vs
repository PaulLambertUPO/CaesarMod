int i;

SpawnGroupInHolder("I_GuardTowerDefence", "S_36");

WaitSettlementCapture("S_36", 1, -1);

EnvWriteInt("/TakenGuardTower", 1);

if (IsNoteActive("GuardTower"))
	RemoveNote("GuardTower");

while (1) {
	if (NO_36.obj.player == 1)
		for (i = 1; i <= 3; i += 1)
			ClassPlayerAreaObjs(cSentry, 4, "A_Sentry" + i).Erase();
	Sleep(1000);
}