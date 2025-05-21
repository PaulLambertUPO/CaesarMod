int assault_interval, timer;

assault_interval = 120000 - GetDifficulty() * 20000;
timer = assault_interval;

WaitEnvIntBetween("/En_IntroEnds", 1, 1, -1);

while (1) {
	Sleep(5000);
	timer -= 5000;
	if (timer <= 0) {
		timer = assault_interval;
		if (NO_GaulOuter.obj.player != 1)
			SpawnGroupInHolder("Q_InnerGRetaliation1", "S_GaulOuter");
	}
	if (NO_GaulOuter.obj.player == 1) {
		StopAIHelper("RetakingInner");
		Q_InnerGRetaliation2.SetCommand("advance", NO_GaulOuter.obj.pos);
		Q_InnerGRetaliation2.AddCommand(false, "capture", NO_GaulOuter);
	}
	else if (NO_GaulCentral.obj.player == 1) {
		if (!IsAIHelperRunning("RetakingInner"))
			RunAIHelper("RetakingInner", "siege", "Q_InnerGRetaliation1", "S_GaulCentral");
	}
	else {
		StopAIHelper("RetakingInner");
		if (!Q_InnerGRetaliation1.IsEmpty()) {
			AttackArea(Q_InnerGRetaliation1, "A_RomanDefPoint" + (rand(8) + 1));
			Q_InnerGRetaliation1.RemoveFromAllGroups();
		}
	}
}