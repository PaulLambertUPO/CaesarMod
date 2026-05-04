//void, int playerid

//this script shows a hint about hero needs

Sleep(40000);

while (true) {
	Sleep(15000);
	if (Count(playerid, cHero) > 0)
		return;
	if (Count(playerid, cMilitary) >= 20) {
		Obj o;
		ShowHint(
			Translate("Hire heroes!"),
			Translate("You should hire some heroes to lead your units and increase their effectiveness."),
			o
		);
		return;
	}
}