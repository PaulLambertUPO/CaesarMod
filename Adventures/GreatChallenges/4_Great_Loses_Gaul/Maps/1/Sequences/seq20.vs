int old_wave, max_waves;

WaitEmptyQuery(R_Intro, -1);

old_wave = -1;
max_waves = EnvReadInt("/En_MaxWaves");

while (EnvReadInt("/En_FinalWave") != 1) {
	Sleep(5000);
	if (EnvReadInt("/En_CurrentWave") > old_wave) {
		old_wave = EnvReadInt("/En_CurrentWave");
		ShowAnnouncement("Wave", Translatef("Remaining Roman armies: %s1", MAX(0, max_waves - old_wave)));
	}
}

ShowAnnouncement("Wave", Translate("The Roman final assault has started"));
Sleep(20000);
HideAnnouncement("Wave");