//void, int playerid

//this script shows a hint about army formations

ObjList player_heroes;
Obj o;
int i;

Sleep(80000);

while (true) {
	Sleep(30000);
	player_heroes = GetPlayerUnits(playerid, cHero);
	for (i = player_heroes.count - 1; i >= 0; i -= 1) {
		o = player_heroes[i];
		if (o.IsAlive)
			if (o.AsHero().HasArmy) {
				ShowHint(
					Translate("Army formations"),
					Translate("All attached units can be arranged in different formations to gain various bonuses: to do so, select the hero, choose a formation from the menu and then use the 'Stand position' command or hold down the right button to choose the army orientation."),
					o
				);
				return;
			}
	}
}