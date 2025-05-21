IntArray defences;
int i, defences_started;

while (defences_started < 5) {
	Sleep(5000);
	for (i = 1; i <= 5; i += 1)
		if (defences[i] != 1)
			if (!ClassPlayerAreaObjs(cMilitary, 1, "A_InnerGaulTown" + i).IsEmpty()) {
				SpawnGroup("Q_InnerGaulsSpawn" + i);
				RunAIHelper("GuardIntoTown" + i, "guard area", "Q_InnerGaulsSpawn" + i, "A_InnerGaulTown" + i);
				defences[i] = 1;
				defences_started += 1;
			}
}