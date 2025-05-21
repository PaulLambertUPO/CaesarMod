int i, w, waves, wave_interval, wave_origin;

waves = 40 + GetDifficulty() * 10;
wave_interval = 60000 - GetDifficulty() * 15000;

WaitEnvIntBetween("/En_IntroEnds", 1, 1, -1);

for (w = 1; w <= waves; w += 1) {
	Sleep(wave_interval);
	for (i = 0; i < 2 + w / 16; i += 1) {
		wave_origin = rand(8) + 1;
		SpawnGroup("Q_OuterGauls" + wave_origin + (rand(3) + 1)).SetCommand("attack", AreaCenter("A_RomanDefPoint" + wave_origin));
	}
	if (w % 10 == 0) {
		SpawnGroupInHolder("Q_WaveRelief1", "S_FortificationPoint1");
		Q_WaveRelief1.RemoveFromAllGroups();
		SpawnGroupInHolder("Q_WaveRelief2", "S_FortificationPoint2");
		Q_WaveRelief2.RemoveFromAllGroups();
		Sleep(wave_interval);
	}
}

EnvWriteInt("/En_AllWavesGone", 1);