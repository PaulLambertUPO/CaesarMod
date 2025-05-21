int difficulty;

difficulty = GetDifficulty();

Sleep(240000 - difficulty * 30000);

while (Q_FinalWave.IsEmpty()) {
	if (Q_UpperCampAssault.IsEmpty()) {
		int i;
		if (IsAIHelperRunning("UpperCampAssault")) {
			StopAIHelper("UpperCampAssault");
			Sleep(1000);
		}
		SpawnGroupInHolder("Q_UpperCampAssault", "S_UnbreakableRomanTown");
		Q_UpperArmyAssault.SetCommand("attach", Q_UpperAssaultHero.GetObjList()[0]);
		Q_UpperAssaultHero.SetCommand("attack", AreaCenter("A_UpperCampAssault"));
		EnvWriteInt("/En_NewMessenger", 1);
		for (i = 0; i < 40 && Q_FinalWave.IsEmpty(); i += 1)
			Sleep(12000 - difficulty * 1500);
	}
	if (Q_FinalWave.IsEmpty()) {
		if (!Intersect(Q_UpperCampAssault, AreaObjs("A_UpperCampAssault", cMilitary)).IsEmpty())
			if (!Q_UpperAssaultHero.IsEmpty())
				Q_UpperAssaultHero.SetCommand("attack", AreaCenter("A_CampAssault"));
			else
				AttackArea(Q_UpperArmyAssault, "A_CampAssault");
		if (!Intersect(Q_UpperCampAssault, AreaObjs("A_CampAssault", cMilitary)).IsEmpty())
			RunAIHelper("UpperCampAssault", "siege", "Q_UpperCampAssault", "S_MainCamp");
	}
	Sleep(10000);
}

if (!IsAIHelperRunning("UpperCampAssault"))
	Q_UpperCampAssault.SetCommand("advanceenter", NO_EnemyTown);