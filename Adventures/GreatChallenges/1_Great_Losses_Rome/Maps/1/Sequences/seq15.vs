int i;
bool broken_gate = false;

GetSettlement("S_TraitorTown").AllowCapture(false);
Sleep(120000);
WaitConvRequest(NO_Hannibal, NO_Traitor, -1);
RunConv("C_Conv3");
RemoveNote("Roman allies.");
GiveNote("Destroy one of the gates to Rome.");
while (!broken_gate) {
	for (i = 1; i < 5; i += 1)
		if (GetNamedObj("NO_RomeGate" + i).obj.health < 300)
			broken_gate = true;
	Sleep(5000);
}
GetSettlement("S_TraitorTown").AllowCapture(true);
RunConv("C_Conv4");
NO_TraitorTown.SetPlayer(1);
NO_TraitorVillage.SetPlayer(1);
RemoveNote("Destroy one of the gates to Rome.");
for (i = 5 - GetDifficulty(); i > 0; i -= 1)
	SpawnGroupInHolder("Q_TraitorHoplites", "S_TraitorTown").RemoveFromGroup("Q_TraitorHoplites");
NO_Traitor.SetCommand("enter", NO_TraitorTown);
NO_TraitorAdviser.SetCommand("enter", NO_TraitorTown);
Sleep(5000);
NO_Traitor.Erase();
NO_TraitorAdviser.Erase();