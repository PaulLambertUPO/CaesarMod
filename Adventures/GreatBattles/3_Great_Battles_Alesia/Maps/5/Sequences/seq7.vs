int assault_interval, timer;

assault_interval = 180000 - GetDifficulty() * 30000;
timer = assault_interval;

WaitEnvIntBetween("/En_IntroEnds", 1, 1, -1);

while (1) {
	Sleep(5000);
	timer -= 5000;
	if (timer <= 0) {
		timer = assault_interval;
		if (NO_GaulCentral.obj.player != 1)
			SpawnGroupInHolder("Q_InnerGRetaliation2", "S_GaulCentral");
	}
	if (NO_GaulCentral.obj.player == 1) {
		Q_InnerGRetaliation2.SetCommand("advance", NO_GaulCentral.obj.pos);
		Q_InnerGRetaliation2.AddCommand(false, "capture", NO_GaulCentral);
	}
	else if (NO_GaulOuter.obj.player == 1) {
		Q_InnerGRetaliation2.SetCommand("advance", NO_GaulOuter.obj.pos);
		Q_InnerGRetaliation2.AddCommand(false, "capture", NO_GaulOuter);
	}
	else if (!Q_InnerGRetaliation2.IsEmpty()) {
		AttackArea(Q_InnerGRetaliation2, "A_RomanDefPoint" + (rand(8) + 1));
		Q_InnerGRetaliation2.RemoveFromAllGroups();
	}
}