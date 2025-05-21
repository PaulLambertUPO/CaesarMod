Obj town1, town2, town3;
int timer;

town1 = NO_Town1;
town2 = NO_Town2;
town3 = NO_Town3;

while (1) {
	Sleep(10000);
	timer -= 10000;
	if (timer <= 0) {
		timer = 360000;
		if (town2.player != 1)
			SpawnGroup("R_GoldSpawn");
		else if (town3.player != 1)
			SpawnGroup("R_GoldSpawn");
		else if (town1.player != 1)
			SpawnGroup("R_GoldSpawn");
	}
	if (!R_GoldSpawn1.IsEmpty())
		if (town2.player != 1)
			R_GoldSpawn1.SetCommand("unload", town2);
		else if (town3.player != 1)
			R_GoldSpawn1.SetCommand("unload", town3);
		else if (town1.player != 1)
			R_GoldSpawn1.SetCommand("unload", town1);
	if (!R_GoldSpawn2.IsEmpty())
		if (town3.player != 1)
			R_GoldSpawn2.SetCommand("unload", town3);
		else if (town2.player != 1)
			R_GoldSpawn2.SetCommand("unload", town2);
		else if (town1.player != 1)
			R_GoldSpawn2.SetCommand("unload", town1);
}