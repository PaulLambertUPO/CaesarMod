//void, int playerid

//this script shows a hint about hero skill points

ObjList player_heroes;
Obj obj;
int i;

Sleep(30000);

while (1) {
	Sleep(5000);
	player_heroes = GetPlayerUnits(playerid, cHero);
	for (i = 0; i < player_heroes.count; i += 1) {
		obj = player_heroes[i];
		if (obj.IsValid)
			if (!obj.IsDead())
				if (obj.AsHero().AvailableSkillPoints() > 0) {
					ShowHint(
						Translate("Hero advancement"),
						Translate("Every time that a hero levels up, a skill point can be used to improve one of his skills (a '+' appears in the upper part of the screen when the hero is selected)."),
						obj
					);
					return;
				}
	}
}