ObjList ol_temp;
int difficulty, wave, army_status, i, r, l, t;

difficulty = GetDifficulty();

Sleep(300000 - difficulty * 60000);

while (1) {
	r = rand(3) + 2;
	while (r > 0) {
		SpawnGroup("Q_MainGoulWave" + (rand(3) + 1));
		SpawnGroup("Q_MainGoulWave" + (rand(3) + 1));
		if (r % 2 == 1)
			SpawnGroup("Q_MainGoulWave4").RemoveFromGroup("Q_MainGoulWave5");
		else
			SpawnGroup("Q_MainGoulWave5").RemoveFromGroup("Q_MainGoulWave4");
		if (!Q_PreviousMain.IsEmpty()) {
			Q_PreviousMain.AddToGroup("Q_MainGaulArmy1");
			Q_PreviousMain.AddToGroup("Q_MainGaulArmy2");
			Q_PreviousMain.RemoveFromGroup("Q_PreviousMain");
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
	ol_temp = Q_MainGaulArmy.GetObjList();
	for (i = 0; i < ol_temp.count; i += 1) {
		ol_temp[i].AsUnit().SetFood(20);
		ol_temp[i].AsUnit().SetLevel(l * (1 + difficulty));
	}
	ol_temp = Q_MainGaulArmyArchers.GetObjList();
	for (i = 0; i < ol_temp.count; i += 1) {
		ol_temp[i].AsUnit().SetFood(20);
		ol_temp[i].AsUnit().SetLevel(l * (1 + difficulty));
	}
	if (!Q_MainGaulArmy1.IsEmpty())
		AttackArea(Q_MainGaulArmy1, "A_LeftPos1");
	if (!Q_MainGoulWave4.IsEmpty())
		AttackArea(Q_MainGoulWave4, "A_LeftPos1");
	if (!Q_MainGaulArmy2.IsEmpty())
		AttackArea(Q_MainGaulArmy2, "A_MiddlePos1");
	if (!Q_MainGoulWave5.IsEmpty())
		AttackArea(Q_MainGoulWave5, "A_MiddlePos1");
	Sleep(35000);
	if (!Q_MainGaulArmy1.IsEmpty())
		AttackArea(Q_MainGaulArmy1, "A_LeftPos2");
	if (!Q_MainGoulWave4.IsEmpty())
		AttackArea(Q_MainGoulWave4, "A_LeftPos2");
	if (!Q_MainGaulArmy2.IsEmpty())
		AttackArea(Q_MainGaulArmy2, "A_MiddlePos2");
	if (!Q_MainGoulWave5.IsEmpty())
		AttackArea(Q_MainGoulWave5, "A_MiddlePos2");
	Sleep(60000);
	if (!Q_MainGaulArmy1.IsEmpty())
		AttackArea(Q_MainGaulArmy1, "A_LeftPos3");
	if (!Q_MainGoulWave4.IsEmpty())
		AttackArea(Q_MainGoulWave4, "A_LeftPos3");
	if (!Q_MainGaulArmy2.IsEmpty())
		AttackArea(Q_MainGaulArmy2, "A_MiddlePos3");
	if (!Q_MainGoulWave5.IsEmpty())
		AttackArea(Q_MainGoulWave5, "A_MiddlePos3");
	Sleep(120000);
	if (!Q_MainGoulWave4.IsEmpty())
		Q_MainGoulWave4.SetCommand("attack", NO_LeftPos.obj.pos);
	if (!Q_MainGoulWave5.IsEmpty())
		Q_MainGoulWave5.SetCommand("attack", NO_MiddlePos.obj.pos);
	Sleep(40000);
	if (!Q_MainGoulWave4.IsEmpty()) {
		Q_MainGoulWave4.SetCommand("attack", NO_LeftPos);
		EnvWriteInt("/En_ArchersAlone", 1);
	}
	if (!Q_MainGoulWave5.IsEmpty()) {
		Q_MainGoulWave5.SetCommand("attack", NO_MiddlePos);
		EnvWriteInt("/En_ArchersAlone", 1);
	}
	army_status = 0;
	while (army_status == 0) {
		if (WaitHealthBetween(Q_LeftPos, 0, 10, 2000))
			army_status = 1;
		else if (WaitHealthBetween(Q_MiddlePos, 0, 10, 2000))
			army_status = 1;
		if (Q_MainGoulWave4.IsEmpty())
			if (Q_MainGoulWave5.IsEmpty())
				army_status = 2;
	}
	if (army_status == 1) {
		RunAIHelper("AttackingRomanTown2", "guard area", "Q_MainGaulArmy", "A_Village7");
		RunAIHelper("AttackingRomanTown3", "guard area", "Q_MainGaulArmyArchers", "A_Village7");
	}
	else {
		if (!Q_MainGaulArmy1.IsEmpty()) {
			Q_MainGaulArmy1.AddToGroup("Q_PreviousMain");
			ol_temp = Q_MainGaulArmy1.GetObjList();
			for (i = 0; i < ol_temp.count; i += 1)
				ol_temp[i].AsUnit().SetFood(0);
			AttackArea(Q_MainGaulArmy1, "A_GermanCamp");
			EnvWriteInt("/En_SendChasers", 1);
		}
		if (!Q_MainGaulArmy2.IsEmpty()) {
			Q_MainGaulArmy2.AddToGroup("Q_PreviousMain");
			ol_temp = Q_MainGaulArmy2.GetObjList();
			for (i = 0; i < ol_temp.count; i += 1)
				ol_temp[i].AsUnit().SetFood(0);
			AttackArea(Q_MainGaulArmy2, "A_GermanCamp");
			EnvWriteInt("/En_SendChasers", 1);
		}
	}
	Sleep(t - difficulty * 30000);
	wave += 1;
	EnvWriteInt("/En_TotalWaves", wave);
}