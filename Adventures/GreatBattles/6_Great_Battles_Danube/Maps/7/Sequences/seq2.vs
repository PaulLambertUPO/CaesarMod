ObjList ol_temp;
int difficulty, wave, army_status, i, r, l, t;

difficulty = GetDifficulty();

Sleep(300000 - difficulty * 60000);

while (1) {
	r = rand(4) + 2;
	while (r > 0) {
		SpawnGroup("Q_RightGoulWave1");
		SpawnGroup("Q_RightGoulWave2");
		if (!Q_PreviousRight.IsEmpty()) {
			Q_PreviousRight.AddToGroup("Q_RightGoulWave1");
			Q_PreviousRight.RemoveFromGroup("Q_PreviousRight");
		}
		r -= 1;
	}
	if (wave < 8 + 2 * difficulty) {
		l = MAX(1, wave);
		t = 120000;
	}
	else {
		l = 6;
		t = 300000;
	}
	ol_temp = Q_RightGoulArmy.GetObjList();
	for (i = 0; i < ol_temp.count; i += 1) {
		ol_temp[i].AsUnit().SetFood(20);
		ol_temp[i].AsUnit().SetLevel(l * (1 + difficulty));
	}
	if (!Q_RightGoulWave1.IsEmpty())
		AttackArea(Q_RightGoulWave1, "A_RightPos1");
	if (!Q_RightGoulWave2.IsEmpty())
		AttackArea(Q_RightGoulWave2, "A_RightPos1");
	Sleep(35000);
	if (!Q_RightGoulWave1.IsEmpty())
		AttackArea(Q_RightGoulWave1, "A_RightPos2");
	if (!Q_RightGoulWave1.IsEmpty())
		AttackArea(Q_RightGoulWave2, "A_RightPos2");
	Sleep(60000);
	if (!Q_RightGoulWave1.IsEmpty())
		AttackArea(Q_RightGoulWave1, "A_RightPos3");
	if (!Q_RightGoulWave2.IsEmpty())
		AttackArea(Q_RightGoulWave2, "A_RightPos3");
	Sleep(120000);
	if (!Q_RightGoulWave2.IsEmpty())
		Q_RightGoulWave2.SetCommand("attack", NO_RightPos.obj.pos);
	Sleep(40000);
	if (!Q_RightGoulWave2.IsEmpty()) {
		Q_RightGoulWave2.SetCommand("attack", NO_RightPos);
		EnvWriteInt("/En_ArchersAlone", 1);
	}
	army_status = 0;
	while (army_status == 0) {
		if (WaitHealthBetween(Q_RightPos, 0, 10, 2000))
			army_status = 1;
		if (Q_RightGoulWave2.IsEmpty())
			army_status = 2;
	}
	if (army_status == 1)
		RunAIHelper("AttackingRomanTown1", "guard area", "Q_RightGoulArmy", "A_Village7");
	else if (!Q_RightGoulWave1.IsEmpty()) {
		Q_RightGoulWave1.AddToGroup("Q_PreviousRight");
		ol_temp = Q_RightGoulArmy.GetObjList();
		for (i = 0; i < ol_temp.count; i += 1)
			ol_temp[i].AsUnit().SetFood(0);
		AttackArea(Q_PreviousRight, "A_Ruins");
		EnvWriteInt("/En_SendChasers", 1);
	}
	Sleep(t - difficulty * 30000);
	wave += 1;
}