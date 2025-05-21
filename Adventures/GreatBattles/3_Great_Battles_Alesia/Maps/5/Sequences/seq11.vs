IntArray auto_spawns;
int i, spawned;

while (spawned < 4) {
	Sleep(1000);
	for (i = 1; i <= 4; i += 1)
		if (auto_spawns[i] != 1)
			if (!Union(
						ClassPlayerAreaObjs(cMilitary, 4, "A_AutoSpawn" + i),
						ClassPlayerAreaObjs(cMilitary, 5, "A_AutoSpawn" + i)
					).IsEmpty()) {
				SpawnGroup("Q_AutoSpawn" + i).SetCommand("attack", AreaCenter("A_AutoSpawn" + i));
				auto_spawns[i] = 1;
				spawned += 1;
			}
}