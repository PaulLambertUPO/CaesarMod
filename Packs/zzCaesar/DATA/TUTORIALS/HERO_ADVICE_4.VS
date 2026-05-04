//void, int playerid

//this script shows a hint about hero skill points

ObjList player_heroes;
Obj o;
int i;

Sleep(30000);

while (true) {
	Sleep(5000);
	player_heroes = GetPlayerUnits(playerid, cHero);
	for (i = player_heroes.count - 1; i >= 0; i -= 1) {
		o = player_heroes[i];
		if (o.IsAlive)
			if (o.AsHero().AvailableSkillPoints() > 0) {
				ShowHint(
					Translate("Hero advancement"),
					Translate("Every time that a hero levels up, a skill point can be used to improve one of his skills (a '+' appears in the upper part of the screen when the hero is selected)."),
					o
				);
				return;
			}
	}
}