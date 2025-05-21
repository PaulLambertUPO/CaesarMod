IntArray guards;
int i, guards_started;

while (guards_started < 3) {
	Sleep(4000);
	for (i = 1; i <= 3; i += 1)
		if (guards[i] != 1)
			if (!ClassPlayerAreaObjs(cMilitary, 1, "A_Roaming" + i).IsEmpty()) {
				if (i == 3)
					SpawnGroup("Q_Roaming3");
				RunAIHelper("Roam" + i, "guard area", "Q_Roaming" + i, "A_Roaming" + i);
				guards[i] = 1;
				guards_started += 1;
			}
}