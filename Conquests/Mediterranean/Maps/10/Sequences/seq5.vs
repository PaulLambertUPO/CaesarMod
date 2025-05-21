IntArray camps_subgroups;
int i, j;

I_Heroes.SetCommand("stand_position");

for (i = 1; i <= 3; i += 1) {
	camps_subgroups[i] = 1;
	GetNamedObj("NO_Hero" + i).obj.AsHero().SetAutocast(true);
	for (j = 1; j <= 3; j += 1)
		Group("I_Patrol" + i + j).SetCommand("patrol", AreaCenter("A_Patrol" + i + j));
}

while (!I_Heroes.IsEmpty()) {
	for (i = 1; i <= 3; i += 1)
		if (!Group("I_Hero" + i).IsEmpty())
			if (Group("I_Spawn" + i).count < 30)
				if (!ClassPlayerAreaObjs(cMilitary, 1, "A_Camp" + i).IsEmpty()) {
					j = camps_subgroups[i];
					SpawnGroup("I_Spawn" + i + j).SetCommand("attach", GetNamedObj("NO_Hero" + i));
					Sleep(500);
					if (!IsAIHelperRunning("GuardCamp" + i))
						RunAIHelper("GuardCamp" + i, "guard area", "I_Camp" + i, "A_Camp" + i);
					camps_subgroups[i] += 1;
					if (camps_subgroups[i] > 5)
						camps_subgroups[i] = 1;
				}
	Sleep(15000);
}