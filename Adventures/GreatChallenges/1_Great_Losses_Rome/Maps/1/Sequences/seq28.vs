int difficulty, r1, r2;

difficulty = GetDifficulty();

Sleep(420000 - difficulty * 60000);

while (1) {
	Sleep(300000 - difficulty * 60000);
	WaitEmptyQuery(Q_Destroyers1, -1);
	WaitEmptyQuery(Q_Destroyers2, -1);
	WaitEmptyQuery(Q_Destroyers3, -1);
	WaitEmptyQuery(Q_Destroyers4, -1);
	WaitEmptyQuery(Q_LegionCommander1, -1);
	WaitEmptyQuery(Q_LegionCommander2, -1);
	WaitEmptyQuery(Q_LegionCommander3, -1);
	WaitEmptyQuery(Q_LegionCommander4, -1);
	r1 = rand(4) + 1;
	r2 = rand(4) + 1;
	while (r1 == r2)
		r1 = rand(4) + 1;
	SpawnGroup("Q_Destroyers" + r1);
	SpawnGroup("Q_Destroyers" + r2);
	SpawnGroup("Q_LegionCommander" + r1);
	SpawnGroup("Q_LegionCommander" + r2);
	Group("Q_Destroyers" + r1).SetCommand("attach", GetNamedObj("NO_LegionCommander" + r1));
	Group("Q_Destroyers" + r2).SetCommand("attach", GetNamedObj("NO_LegionCommander" + r2));
	GetNamedObj("NO_LegionCommander" + r1).SetCommand("attack", AreaCenter("A_LegionDest" + r1));
	GetNamedObj("NO_LegionCommander" + r2).SetCommand("attack", AreaCenter("A_LegionDest" + r2));
	GetNamedObj("NO_LegionCommander" + r1).obj.AsHero().SetAutocast(true);
	GetNamedObj("NO_LegionCommander" + r2).obj.AsHero().SetAutocast(true);
}