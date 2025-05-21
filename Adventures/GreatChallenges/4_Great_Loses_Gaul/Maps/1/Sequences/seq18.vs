ObjList ol;
int max_waves, chieftains_timer, i, r;

WaitEmptyQuery(R_Intro, -1);

Sleep(300000 - GetDifficulty() * 60000);

max_waves = EnvReadInt("/En_MaxWaves");

chieftains_timer = 15000 - GetDifficulty() * 3000;

while (EnvReadInt("/En_CurrentWave") < max_waves) {
	i = 0;
	while (i < 2) {
		r = rand(8) + 1;
		if (EnvReadInt("/En_AttackCorridor" + r) == 0) {
			if (G_Chieftains.count < 5)
				break;
			EnvWriteInt("/En_AttackCorridor" + r, 1);
			i += 1;
		}
		Sleep(1000);
	}
	for (i = 0; i < 10; i += 1)
		if (G_Chieftains.count < 5)
			i = 11;
		else
			Sleep(chieftains_timer);
	if (i >= 11)
		break;
}

EnvWriteInt("/En_FinalWave", 1);