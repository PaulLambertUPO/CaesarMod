//void, int playerid

//this script shows a hint about faster healing

ObjList player_units;
Obj o;
int i, j, total_current_health, total_max_health;

Sleep(150000);

while (true) {
	Sleep(60000);
	player_units = ClassPlayerObjs(cMilitary, playerid).GetObjList();
	if (player_units.count >= 25) {
		j = 0;
		total_current_health = 0;
		total_max_health = 0;
		for (i = player_units.count - 1; i >= 0; i -= 1) {
			o = player_units[i];
			if (o.IsAlive) {
				total_current_health += o.health;
				total_max_health += o.maxhealth;
			}
			j += 1;
			if (j >= 50)//check up to 50 units to avoid overhead
				break;
		}
		if (total_current_health < total_max_health / 3) {
			ShowHint(
				Translate("Faster healing"),
				Translate("When the health of your units is low, order them to enter a townhall or an outpost because they will heal faster while sheltered (provided that there is enough food)."),
				o
			);
			return;
		}
	}
}