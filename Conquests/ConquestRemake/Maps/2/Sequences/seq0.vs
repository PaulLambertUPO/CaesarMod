Settlement set2, set3, set4, set5, set6;

set2 = GetSettlement("S_Town2");
set3 = GetSettlement("S_Town3");
set4 = GetSettlement("S_Town4");
set5 = GetSettlement("S_Town5");
set6 = GetSettlement("S_Town6");

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
	if (set4.player != 1) {
		SpawnGroupInHolder("C_Reinforcements3", "S_Town4");
		C_Reinforcements3.SetPlayer(set4.player);
		C_Reinforcements3.RemoveFromAllGroups();
	}
	if (set5.player != 1) {
		SpawnGroupInHolder("C_Reinforcements4", "S_Town5");
		C_Reinforcements4.SetPlayer(set5.player);
		C_Reinforcements4.RemoveFromAllGroups();
	}
	if (set6.player != 1) {
		SpawnGroupInHolder("C_Reinforcements5", "S_Town6");
		C_Reinforcements5.SetPlayer(set6.player);
		C_Reinforcements5.RemoveFromAllGroups();
	}
}