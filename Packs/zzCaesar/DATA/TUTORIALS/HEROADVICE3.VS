//void, int playerid

//this script shows a hint about hero bonuses

ObjList player_heroes;
Obj obj;
int i;

Sleep(120000);

while (1) {
	Sleep(5000);
	player_heroes = GetPlayerUnits(playerid, cHero);
	for (i = 0; i < player_heroes.count; i += 1) {
		obj = player_heroes[i];
		if (obj.AsHero().army.count >= 1) {
			ShowTutorial(
				Translate("Hero bonuses"),
				Translate("All heroes have some special skills that improve the combat skills of their attached units and/or theirs: some are passive, while others are activable to gain a temporary bonus by spending some stamina."),
				obj
			);
			return;
		}
	}
}