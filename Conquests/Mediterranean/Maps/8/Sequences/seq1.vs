while (1) {
	if (NO_Town2.obj.player != 1) {
		SpawnGroupInHolder("T_Valkyries1", "S_Town2");
		T_Valkyries1.SetPlayer(NO_Town2.obj.player);
		T_Valkyries1.RemoveFromAllGroups();
	}
	if (NO_Town3.obj.player != 1) {
		SpawnGroupInHolder("T_Valkyries2", "S_Town3");
		T_Valkyries2.SetPlayer(NO_Town3.obj.player);
		T_Valkyries2.RemoveFromAllGroups();
	}
	Sleep(600000);
}