while (1) {
	if (NO_Town2.obj.player != 1)
		if (NO_Town2.obj.player != 7) {
			SpawnGroupInHolder("T_Valkyries1", "S_Town2");
			T_Valkyries1.SetPlayer(NO_Town2.obj.player);
			T_Valkyries1.RemoveFromAllGroups();
		}
	if (NO_Town3.obj.player != 1)
		if (NO_Town3.obj.player != 7) {
			SpawnGroupInHolder("T_Valkyries2", "S_Town3");
			T_Valkyries2.SetPlayer(NO_Town3.obj.player);
			T_Valkyries2.RemoveFromAllGroups();
		}
	if (NO_Town4.obj.player != 1)
		if (NO_Town4.obj.player != 7) {
			SpawnGroupInHolder("T_Valkyries3", "S_Town4");
			T_Valkyries3.SetPlayer(NO_Town4.obj.player);
			T_Valkyries3.RemoveFromAllGroups();
		}
	if (NO_Town6.obj.player != 1)
		if (NO_Town6.obj.player != 7) {
			SpawnGroupInHolder("T_Valkyries4", "S_Town6");
			T_Valkyries4.SetPlayer(NO_Town6.obj.player);
			T_Valkyries4.RemoveFromAllGroups();
		}
	Sleep(600000);
}