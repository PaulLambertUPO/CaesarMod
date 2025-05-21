while (1) {
	Sleep(300000);
	if (NO_Town2.obj.player != 1)
		if (I_Enchantresses.count < 5)
			SpawnGroupInHolder("I_Enchantresses", "S_Town2");
}