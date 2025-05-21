//void, int playerid

//this script shows a hint about unit stats

ObjList player_units;

Sleep(170000);

while (1) {
	Sleep(10000);
	player_units = ClassPlayerObjs(cMilitary, playerid).GetObjList();
	if (player_units.count > 0) {
		ShowTutorial(
			Translate("Unit stats"),
			Translate("Every unit has its unique set of stats and you can check them by selecting it and looking at the upper left corner of the screen. The main stats shown are: level, damage, stamina, armor, health, food and specials. On the right there are also the items currently owned by the unit. In case of a hero/ship, there is also the list of units attached/aboard."),
			player_units[rand(player_units.count)]
		);
		return;
	}
}