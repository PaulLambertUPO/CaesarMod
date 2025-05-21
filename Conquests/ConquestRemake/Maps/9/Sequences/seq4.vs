Obj town2, town3, town4, town5;
int timer, interval = 10000;

town2 = NO_Town2;
town3 = NO_Town3;
town4 = NO_Town4;
town5 = NO_Town5;

while (1) {
	Sleep(interval);
	timer -= interval;
	if (timer <= 0) {
		timer = 360000;
		if (town2.player != 1 && town2.player != 7 && town2.player != 8)
			SpawnGroup("R_GoldSpawn");
		else if (town3.player != 1 && town3.player != 7 && town3.player != 8)
			SpawnGroup("R_GoldSpawn");
		else if (town4.player != 1 && town4.player != 7 && town4.player != 8)
			SpawnGroup("R_GoldSpawn");
		else if (town5.player != 1)
			if (town5.player != 7)
				if (town5.player != 8)
					SpawnGroup("R_GoldSpawn");
	}

	if (!R_GoldSpawn1.IsEmpty())
		if (town3.player != 1 && town3.player != 7 && town3.player != 8)
			R_GoldSpawn1.SetCommand("unload", town3);
		else if (town5.player != 1 && town5.player != 7 && town5.player != 8)
			R_GoldSpawn1.SetCommand("unload", town5);
		else if (town2.player != 1 && town2.player != 7 && town2.player != 8)
			R_GoldSpawn1.SetCommand("unload", town2);
		else if (town4.player != 1)
			if (town4.player != 7)
				if (town4.player != 8)
					R_GoldSpawn1.SetCommand("unload", town4);

	if (!R_GoldSpawn2.IsEmpty())
		if (town5.player != 1 && town5.player != 7 && town5.player != 8)
			R_GoldSpawn2.SetCommand("unload", town5);
		else if (town3.player != 1 && town3.player != 7 && town3.player != 8)
			R_GoldSpawn2.SetCommand("unload", town3);
		else if (town2.player != 1 && town2.player != 7 && town2.player != 8)
			R_GoldSpawn2.SetCommand("unload", town2);
		else if (town4.player != 1)
			if (town4.player != 7)
				if (town4.player != 8)
					R_GoldSpawn2.SetCommand("unload", town4);

	if (!R_GoldSpawn3.IsEmpty())
		if (town2.player != 1 && town2.player != 7 && town2.player != 8)
			R_GoldSpawn3.SetCommand("unload", town2);
		else if (town5.player != 1 && town5.player != 7 && town5.player != 8)
			R_GoldSpawn3.SetCommand("unload", town5);
		else if (town4.player != 1 && town4.player != 7 && town4.player != 8)
			R_GoldSpawn3.SetCommand("unload", town4);
		else if (town3.player != 1)
			if (town3.player != 7)
				if (town3.player != 8)
					R_GoldSpawn3.SetCommand("unload", town3);

	if (!R_GoldSpawn4.IsEmpty())
		if (town4.player != 1 && town4.player != 7 && town4.player != 8)
			R_GoldSpawn4.SetCommand("unload", town4);
		else if (town5.player != 1 && town5.player != 7 && town5.player != 8)
			R_GoldSpawn4.SetCommand("unload", town5);
		else if (town2.player != 1 && town2.player != 7 && town2.player != 8)
			R_GoldSpawn4.SetCommand("unload", town2);
		else if (town3.player != 1)
			if (town3.player != 7)
				if (town3.player != 8)
					R_GoldSpawn4.SetCommand("unload", town3);
}