//void, int playerid

//this script shows a hint about village population

ObjList player_villages;
Obj o;
int i;

Sleep(160000);

while (true) {
	Sleep(20000);
	player_villages = GetSettlements(cBaseVillage, playerid);
	for (i = player_villages.count - 1; i >= 0; i -= 1) {
		o = player_villages[i];
		if (o.AsBuilding().settlement.population < o.AsBuilding().settlement.max_population / 3) {
			ShowHint(
				Translate("Village population"),
				Translate("The more population your villages have, the more food they produce. Do not let your population decrease too much or your units will starve! It grows automatically over time unless it drops below 10, but you can call peasants from other villages and place them in the village hall to speed up the process."),
				o
			);
			return;
		}
	}
}