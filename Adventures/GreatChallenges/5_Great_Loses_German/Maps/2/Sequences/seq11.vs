int difficulty;

difficulty = GetDifficulty();

Sleep(120000 - difficulty * 30000);

while (Q_FinalWave.IsEmpty()) {
	if (Q_LowerCampAssault.IsEmpty()) {
		int i;
		if (IsAIHelperRunning("LowerCampAssault")) {
			StopAIHelper("LowerCampAssault");
			Sleep(1000);
		}
		SpawnGroupInHolder("Q_LowerCampAssault", "S_UnbreakableRomanTown");
		Q_LowerArmyAssault.SetCommand("attach", Q_LowerAssaultHero.GetObjList()[0]);
		Q_LowerAssaultHero.SetCommand("attack", AreaCenter("A_LowerCampAssault"));
		EnvWriteInt("/En_NewMessenger", 1);
		for (i = 0; i < 30 && Q_FinalWave.IsEmpty(); i += 1)
			Sleep(12000 - difficulty * 1000);
	}
	if (Q_FinalWave.IsEmpty()) {
		if (!Intersect(Q_LowerCampAssault, AreaObjs("A_LowerCampAssault", cMilitary)).IsEmpty())
			if (!Q_LowerAssaultHero.IsEmpty())
				Q_LowerAssaultHero.SetCommand("attack", AreaCenter("A_CampAssault"));
			else
				AttackArea(Q_LowerArmyAssault, "A_CampAssault");
		if (!Intersect(Q_LowerCampAssault, AreaObjs("A_CampAssault", cMilitary)).IsEmpty())
			RunAIHelper("LowerCampAssault", "siege", "Q_LowerCampAssault", "S_MainCamp");
	}
	Sleep(10000);
}

if (!IsAIHelperRunning("LowerCampAssault"))
	Q_LowerCampAssault.SetCommand("advanceenter", NO_EnemyTown);