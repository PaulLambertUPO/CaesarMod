int p;

while (1) {
	Sleep(300000);
	p = NO_Town2.obj.player;
	if (p != 1)
		if (p != 7)
			if (p != 8)
				if (I_Enchantresses1.count < 5) {
					SpawnGroupInHolder("I_Enchantresses1", "S_Town2");
					I_Enchantresses1.SetPlayer(p);
				}
	p = NO_Town3.obj.player;
	if (p != 1)
		if (p != 7)
			if (p != 8)
				if (I_Enchantresses2.count < 5) {
					SpawnGroupInHolder("I_Enchantresses2", "S_Town3");
					I_Enchantresses2.SetPlayer(p);
				}
	p = NO_Town4.obj.player;
	if (p != 1)
		if (p != 7)
			if (p != 8)
				if (I_Enchantresses3.count < 5) {
					SpawnGroupInHolder("I_Enchantresses3", "S_Town4");
					I_Enchantresses3.SetPlayer(p);
				}
}