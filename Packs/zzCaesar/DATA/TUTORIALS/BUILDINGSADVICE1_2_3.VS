//void, int playerid

//this script shows a hint about capturing a building

ObjList enemy_buildings;
IntArray visible_enemy_buildings, enemy_loyalty;
Obj obj;
int i;

Sleep(100000);

enemy_buildings = Subtract(EnemyObjs(playerid, cBuilding), EnemyObjs(playerid, cTTent)).GetObjList();
for (i = 0; i < enemy_buildings.count; i += 1) {
	visible_enemy_buildings[i] = 0;
	enemy_loyalty[i] = 0;
}

while (1) {
	Sleep(20000);
	for (i = 0; i < enemy_buildings.count; i += 1) {
		obj = enemy_buildings[i];
		if (obj.player != 15)
			if (obj.player != playerid) {
				if (!Intersect(ObjsInCircle(obj.pos, 500, cMilitary), ClassPlayerObjs(cMilitary, playerid)).IsEmpty()) {//if player units are near an enemy building
					if (visible_enemy_buildings[i] == 0) {
						visible_enemy_buildings[i] += 1;
						enemy_loyalty[i] = obj.AsBuilding().settlement.loyalty;
					}
					else if (obj.AsBuilding().settlement.loyalty >= enemy_loyalty[i])
						visible_enemy_buildings[i] += 1;
					else
						visible_enemy_buildings[i] = 0;
				}
				if (visible_enemy_buildings[i] > 1) {//show hint only from the second time an enemy building is detected with loyalty not decreasing
					ShowHint(
						Translate("Capturing buildings"),
						Translate("When your forces are near an enemy building you can order them to capture it by selecting your warriors and right-clicking on it. To successfully perform the capturing process, however, it is necessary that your troops are more than the defenders of the building. As time passes, the loyalty of the building will slowly decrease and when it falls to 0 the building will be yours to control. You can also instantly capture allied buildings by ordering one single warrior to do so."),
						obj
					);
					return;
				}
			}
	}
}