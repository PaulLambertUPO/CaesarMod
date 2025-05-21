//void, int playerid

//this script shows a hint about starving units

Sleep(180000);

while (1) {
	Sleep(10000);
	if (HasStarvingArmy(20000)) {
		ShowHint(
			Translate("Lack of food"),
			Translate("Some of your units are starving! Their health will slowly decrease to 10% of the maximum value. Send them to a settlement with food or bring them a food caravan to feed them and restore their health."),
			StarvingArmyPos(20000)
		);
		return;
	}
}