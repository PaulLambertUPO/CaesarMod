//void, int playerid

//this script shows a hint about town population

ObjList player_townhalls;
Obj o;
int i;

Sleep(130000);

while (true) {
	Sleep(20000);
	player_townhalls = GetSettlements(cBaseTownhall, playerid);
	for (i = player_townhalls.count - 1; i >= 0; i -= 1) {
		o = player_townhalls[i];
		if (o.AsBuilding().settlement.population < o.AsBuilding().settlement.max_population / 3) {
			ShowHint(
				Translate("Town population"),
				Translate("The more population your towns have, the more resources they produce. Do not let your population decrease too much! It grows automatically over time unless it drops below 10, but you can either spend resources in the tavern/market or call peasants from your villages and place them in the townhall to speed up the process."),
				o
			);
			return;
		}
	}
}