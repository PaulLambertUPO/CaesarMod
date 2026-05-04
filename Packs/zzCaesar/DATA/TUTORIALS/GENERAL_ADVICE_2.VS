//void, int playerid

//this script shows a hint about groups assignment

Sleep(300000);

while (true) {
	Sleep(30000);
	if (Count(playerid, cMilitary) > 0) {
		if (!WasSelectionAssigned(playerid))
			if (!IsSelectionAssigned(playerid)) {
				Obj o;
				ShowHint(
					Translate("Assigning groups"),
					Translate("You may assign a group of units or a building to a number by selecting them and pressing both CTRL and a number from 0 to 9. Then, to select the group, you just need to press that number. Groups from 1 to 5 are also shown in the icons on the left side of the screen."),
					o
				);
			}
		return;
	}
}