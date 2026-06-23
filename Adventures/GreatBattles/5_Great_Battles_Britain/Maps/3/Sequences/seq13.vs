bool not_used_rain = true, not_used_horde = true;

while (not_used_rain || not_used_horde) {
	if (not_used_rain)
		if (real_stonehenge.obj.command == "gold_rain") {
			real_stonehenge.obj.CmdDisable("gold_rain");
			not_used_rain = false;
		}
	if (not_used_horde)
		if (real_stonehenge.obj.command == "teuton_horde") {
			real_stonehenge.obj.CmdDisable("teuton_horde");
			not_used_horde = false;
		}
	Sleep(5000);
}