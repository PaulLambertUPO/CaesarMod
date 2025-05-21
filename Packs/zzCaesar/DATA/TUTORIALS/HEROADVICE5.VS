//void, int playerid

//this script shows a hint about army formations

ObjList player_heroes;
IntArray form_status;
Obj obj;
Hero h;
int i;

Sleep(80000);

for (i = 0; i < 6; i += 1)
	form_status[i] = 0;

while (1) {
	Sleep(30000);
	player_heroes = GetPlayerUnits(playerid, cHero);
	for (i = 0; i < player_heroes.count; i += 1) {
		obj = player_heroes[i];
		h = obj.AsHero();
		if (h.IsValid)
			if (h.army.count > 0) {
				if (form_status[0] == 0)
					if (h.formation == "Front") {
						ShowHint(
							Translate("Front formation"),
							Translate("All attached units can be arranged in different formations to gain various bonuses: to do so, select the hero, then choose a formation from the menu and either use the command 'Stand ground' or hold down the right button and choose the army orientation.\n\nThe front formation adds 4 levels."),
							obj
						);
						form_status[0] += 1;
					}
				if (form_status[1] == 0)
					if (h.formation == "Line") {
						ShowHint(
							Translate("Line formation"),
							Translate("All attached units can be arranged in different formations to gain various bonuses: to do so, select the hero, then choose a formation from the menu and either use the command 'Stand ground' or hold down the right button and choose the army orientation.\n\nThe line formation adds 2 damage, 2 armor and 30% range."),
							obj
						);
						form_status[1] += 1;
					}
				if (form_status[2] == 0)
					if (h.formation == "Block") {
						ShowHint(
							Translate("Block formation"),
							Translate("All attached units can be arranged in different formations to gain various bonuses: to do so, select the hero, then choose a formation from the menu and either use the command 'Stand ground' or hold down the right button and choose the army orientation.\n\nThe block formation adds 8 armor and 20% range."),
							obj
						);
						form_status[2] += 1;
					}
				if (form_status[3] == 0)
					if (h.formation == "Cavalry core") {
						ShowHint(
							Translate("Cavalry core formation"),
							Translate("All attached units can be arranged in different formations to gain various bonuses: to do so, select the hero, then choose a formation from the menu and either use the command 'Stand ground' or hold down the right button and choose the army orientation.\n\nThe cavalry core formation adds 4 damage and 30% range."),
							obj
						);
						form_status[3] += 1;
					}
				if (form_status[4] == 0)
					if (h.formation == "Skirmish") {
						ShowHint(
							Translate("Skirmish formation"),
							Translate("All attached units can be arranged in different formations to gain various bonuses: to do so, select the hero, then choose a formation from the menu and either use the command 'Stand ground' or hold down the right button and choose the army orientation.\n\nThe skirmish formation adds 2 damage and 50% range."),
							obj
						);
						form_status[4] += 1;
					}
				if (form_status[5] == 0)
					if (h.formation == "Column") {
						ShowHint(
							Translate("Column formation"),
							Translate("All attached units can be arranged in different formations to gain various bonuses: to do so, select the hero, then choose a formation from the menu and either use the command 'Stand ground' or hold down the right button and choose the army orientation.\n\nThe column formation adds 2 levels and 50% range."),
							obj
						);
						form_status[5] += 1;
					}
			}
		if (form_status[0] > 0)
			if (form_status[1] > 0)
				if (form_status[2] > 0)
					if (form_status[3] > 0)
						if (form_status[4] > 0)
							if (form_status[5] > 0)
								return;
	}
}