Settlement set2, set3;

set2 = GetSettlement("S_Town2");
set3 = GetSettlement("S_Town3");

while (1) {
	Sleep(480000);
	if (set2.player != 1) {
		SpawnGroupInHolder("C_Reinforcements1", "S_Town2");
		C_Reinforcements1.SetPlayer(set2.player);
		C_Reinforcements1.RemoveFromAllGroups();
	}
	if (set3.player != 1) {
		SpawnGroupInHolder("C_Reinforcements2", "S_Town3");
		C_Reinforcements2.SetPlayer(set3.player);
		C_Reinforcements2.RemoveFromAllGroups();
	}
}