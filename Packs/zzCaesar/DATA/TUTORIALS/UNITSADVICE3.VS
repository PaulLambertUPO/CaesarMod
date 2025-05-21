//void, int playerid

//this script shows a hint about hero needs

Sleep(40000);

while (1) {
	Sleep(15000);
	if (Count(playerid, cHero) > 0)
		return;
	if (Count(playerid, cMilitary) >= 20) {
		Obj obj;
		ShowHint(
			Translate("Hire heroes!"),
			Translate("You should hire some heroes to lead your units and increase their effectiveness."),
			obj
		);
		return;
	}
}