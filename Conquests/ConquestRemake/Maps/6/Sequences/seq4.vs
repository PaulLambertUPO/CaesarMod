IntArray ambushes;
int i, j, ambushes_started;

while (ambushes_started < 8) {
	for (i = 0; i < 8; i += 1)
		if (ambushes[i] != 1)
			if (!Union(
						ClassPlayerAreaObjs(cMilitary, 1, "A_Ambush" + i),
						ClassPlayerAreaObjs(cMilitary, 7, "A_Ambush" + i)
					).IsEmpty()) {
				for (j = 0; j < 3; j += 1) {
					SpawnGroup("Ambush" + i).SetCommand("advance", GetRandomPointInArea("A_Ambush" + i));
					Sleep(500);
				}
				ambushes[i] = 1;
				ambushes_started += 1;
			}
	Sleep(1000);
}