IntArray forts_reinforcements;
int difficulty, reinforcements_depleted, i;

difficulty = GetDifficulty();

for (i = 1; i <= 8; i += 1)
	forts_reinforcements[i] = 12 - difficulty * 2;

while (reinforcements_depleted < 8) {
	Sleep(10000);
	for (i = 1; i <= 8; i += 1) {
		if (forts_reinforcements[i] > 0)
			if (GetNamedObj("NO_FortificationPoint" + i).obj.player == 1)
				if (Group("Q_StationGuard" + i).count < 10) {
					if (i <= 4)
						SpawnGroupInHolder("Q_ReinforcementsPoint" + i, "S_FortificationPoint" + i);
					else
						SpawnGroup("Q_ReinforcementsPoint" + i);
					Group("Q_ReinforcementsPoint" + i).AddToGroup("Q_StationGuard" + i);
					forts_reinforcements[i] -= 1;
					if (forts_reinforcements[i] <= 0)
						reinforcements_depleted += 1;
				}
		if (!Group("Q_StationGuard" + i).IsEmpty())
			if (i <= 4 && Intersect(EnemyObjs(1, cMilitary), AreaObjs("A_RomanDefPoint" + i, cMilitary)).IsEmpty()) {
				StopAIHelper("DefendPoint" + i);
				Group("Q_StationGuard" + i).SetCommand("enter", GetNamedObj("NO_FortificationPoint" + i));
			}
			else if (!IsAIHelperRunning("DefendPoint" + i))
				RunAIHelper("DefendPoint" + i, "guard area", "Q_StationGuard" + i, "A_RomanDefPoint" + i);
	}
}