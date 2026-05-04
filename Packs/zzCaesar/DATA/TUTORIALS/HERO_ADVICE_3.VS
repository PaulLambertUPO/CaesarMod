//void, int playerid

//this script shows a hint about hero bonuses

ObjList player_heroes;
Obj o;
int i;

Sleep(120000);

while (true) {
	Sleep(5000);
	player_heroes = GetPlayerUnits(playerid, cHero);
	for (i = player_heroes.count - 1; i >= 0; i -= 1) {
		o = player_heroes[i];
		if (o.IsAlive)
			if (o.AsHero().HasArmy) {
				ShowTutorial(
					Translate("Hero bonuses"),
					Translate("All heroes have some special skills that improve the combat skills of their attached units and/or theirs: some are passive, while others are activable to gain a temporary bonus by spending some stamina."),
					o
				);
				return;
			}
	}
}