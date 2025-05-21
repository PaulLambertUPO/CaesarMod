int difficulty, i, n;
IntArray replacements;

difficulty = GetDifficulty();

for (i = 0; i < 8; i += 1)
	replacements[i] = 1;

while (1) {
	Sleep(10000 - difficulty * 3000);
	if (NO_OuterTown.obj.player == 4)
		if (!ClassPlayerAreaObjs(cMilitary, 1, "A_OuterRome").IsEmpty()) {
			if (Q_ReplaceableOuterTown.count < 20 + difficulty * 5) {
				n = replacements[0];
				SpawnGroup("Q_ReplaceableOuterTown" + n);
				if (!IsAIHelperRunning("ReplaceableOuterTown"))
					RunAIHelper("ReplaceableOuterTown", "guard area", "Q_ReplaceableOuterTown", "A_OuterRome");
				replacements[0] += 1;
				if (replacements[0] > 5)
					replacements[0] = 1;
			}
		}
		else if (!Q_ReplaceableOuterTown.IsEmpty())
			if (IsAIHelperRunning("ReplaceableOuterTown")) {
				StopAIHelper("ReplaceableOuterTown");
				Q_ReplaceableOuterTown.SetCommand("enter", NO_OuterTown);
			}
	for (i = 1; i < 8; i += 1)
		if (GetNamedObj("NO_InnerTown" + i).obj.player == 4)
			if (!ClassPlayerAreaObjs(cMilitary, 1, "A_InnerRome" + i).IsEmpty()) {
				if (Group("Q_ReplaceableInnerTown" + i).count < 20 + difficulty * 5) {
					n = replacements[i];
					SpawnGroup("Q_ReplaceableInnerTown" + i + n);
					if (!IsAIHelperRunning("ReplaceableInnerTown" + i))
						RunAIHelper("ReplaceableInnerTown" + i, "guard area", "Q_ReplaceableInnerTown" + i, "A_InnerRome" + i);
					replacements[i] += 1;
					if (replacements[i] > 5)
						replacements[i] = 1;
				}
			}
			else if (!Q_ReplaceableInnerTown1.IsEmpty())
				if (IsAIHelperRunning("ReplaceableInnerTown" + i)) {
					StopAIHelper("ReplaceableInnerTown" + i);
					Q_ReplaceableInnerTown1.SetCommand("enter", GetNamedObj("NO_InnerTown" + i));
				}
}