//void, int playerid

//this script shows a hint about village population

ObjList player_villages;
Obj obj;
int i;

Sleep(160000);

while (1) {
	Sleep(20000);
	player_villages = ClassPlayerObjs(cBaseVillage, playerid).GetObjList();
	for (i = 0; i < player_villages.count; i += 1) {
		obj = player_villages[i];
		if (obj.AsBuilding().settlement.population < obj.AsBuilding().settlement.max_population / 3) {
			ShowHint(
				Translate("Village population"),
				Translate("The more population your villages have, the more food they produce. Do not let your population decrease too much or your units will starve! It grows automatically over time unless it drops below 10, but you can call peasants from other villages and place them in the village hall to speed up the process."),
				obj
			);
			return;
		}
	}
}