//void, int playerid

//this script shows a hint about faster healing

ObjList player_units;
Obj obj;
int i;

Sleep(150000);

while (1) {
	Sleep(60000);
	player_units = ClassPlayerObjs(cMilitary, playerid).GetObjList();
	if (player_units.count >= 25) {
		int total_current_health, total_max_health;
		for (i = 0; i < player_units.count && i < 50; i += 1) {//count up to 50 units to avoid overhead
			obj = player_units[i];
			total_current_health += obj.health;
			total_max_health += obj.maxhealth;
		}
		if (total_current_health < total_max_health / 3) {
			ShowHint(
				Translate("Faster healing"),
				Translate("When the health of your units is low, order them to enter a townhall or an outpost because they will heal faster while sheltered (provided that there is enough food)."),
				obj
			);
			return;
		}
	}
}