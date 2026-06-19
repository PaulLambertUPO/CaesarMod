//void, int playerid

//this script shows a hint about capturing a building

ObjList enemy_buildings;
IntArray visible_enemy_buildings, enemy_loyalty;
Obj o;
int i, j;

Sleep(100000);

enemy_buildings = GetSettlements(cBaseTownhall, 0);
enemy_buildings.AddList(GetSettlements(cBaseVillage, 0));
enemy_buildings.AddList(GetSettlements(cBaseShipyard, 0));
enemy_buildings.AddList(GetSettlements(cOutpost, 0));

enemy_buildings = enemy_buildings.ObjEnemy(playerid);

for (i = enemy_buildings.count - 1; i >= 0; i -= 1) {
	o = enemy_buildings[i];
	if (o.AsBuilding().settlement.IsIndependent)
		enemy_buildings.Remove(o);
	else {
		visible_enemy_buildings[j] = 0;
		enemy_loyalty[j] = 0;
		j += 1;
	}
}

if (j > 0)
	while (true) {
		Sleep(20000);
		for (i = 0; i < j; i += 1) {
			o = enemy_buildings[i];
			if (o.player != playerid) {
				if (!Intersect(ObjsInRange(o, cMilitary, 500), ClassPlayerObjs(cMilitary, playerid)).IsEmpty)//if player units are near an enemy building
					if (visible_enemy_buildings[i] == 0) {
						visible_enemy_buildings[i] += 1;
						enemy_loyalty[i] = o.AsBuilding().settlement.loyalty;
					}
					else if (o.AsBuilding().settlement.loyalty >= enemy_loyalty[i])
						visible_enemy_buildings[i] += 1;
					else
						visible_enemy_buildings[i] = 0;
				if (visible_enemy_buildings[i] > 1) {//show hint only from the second time an enemy building is detected with loyalty not decreasing
					ShowTutorial(
						Translate("Capturing buildings"),
						Translate("When your forces are near an enemy building you can order them to capture it by selecting your warriors and right-clicking on it. To successfully perform the capturing process, however, it is necessary that your troops are more than the defenders of the building. As time passes, the loyalty of the building will slowly decrease and when it falls to 0 the building will be yours to control. You can also instantly capture allied buildings by ordering one single warrior to do so."),
						o
					);
					return;
				}
			}
		}
	}