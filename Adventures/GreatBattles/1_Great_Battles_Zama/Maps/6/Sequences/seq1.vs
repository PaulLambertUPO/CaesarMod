int i, guards_started;
IntArray guards;

while (guards_started < 5) {
	Sleep(3000);
	for (i = 1; i <= 5; i += 1)
		if (guards[i] != 1)
			if (!ClassPlayerAreaObjs(cMilitary, 1, "A_Village" + i).IsEmpty()) {
				Sleep(8000);
				SpawnGroup("Q_EnemyVillage" + i);
				RunAIHelper("GuardingVillage" + i, "guard area", "Q_EnemyVillage" + i, "A_Village" + i);
				guards[i] = 1;
				guards_started += 1;
			}
}