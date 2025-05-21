bool used_rain = false, used_horde = false;

while (!used_rain || !used_horde) {
	if (!used_rain)
		if (EnvReadInt("/GoldRainStonehenge") == 1) {
			real_stonehenge.obj.CmdDisable("gold_rain");
			used_rain = true;
		}
	if (!used_horde)
		if (EnvReadInt("/TeutonHordeStonehenge") == 1) {
			real_stonehenge.obj.CmdDisable("teuton_horde");
			used_horde = true;
		}
	Sleep(5000);
}