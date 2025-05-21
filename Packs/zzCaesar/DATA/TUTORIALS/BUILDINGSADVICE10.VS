//void, int playerid

//this script shows a hint about town population

ObjList player_towns;
Obj obj;
int i;

Sleep(130000);

while (1) {
	Sleep(20000);
	player_towns = ClassPlayerObjs(cBaseTownhall, playerid).GetObjList();
	for (i = 0; i < player_towns.count; i += 1) {
		obj = player_towns[i];
		if (obj.AsBuilding().settlement.population < obj.AsBuilding().settlement.max_population / 3) {
			ShowHint(
				Translate("Town population"),
				Translate("The more population your towns have, the more resources they produce. Do not let your population decrease too much! It grows automatically over time unless it drops below 10, but you can either spend resources in the tavern/market or call peasants from your villages and place them in the townhall to speed up the process."),
				obj
			);
			return;
		}
	}
}