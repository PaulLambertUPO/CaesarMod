//void, int playerid

//this script shows a hint about attaching units

ObjList player_heroes;
int i;

Sleep(90000);

player_heroes = GetPlayerUnits(playerid, cHero);

if (player_heroes.count > 0) {
	for (i = 0; i < player_heroes.count; i += 1)
		if (player_heroes[i].AsHero().army.count > 0)
			return;
	ShowTutorial(
		Translate("Attaching units"),
		Translate("It is possible to attach units to a hero to improve the effectiveness of an army by selecting them and right-clicking on the hero. The hero shares some experience and improves the troops with special abilities. Up to 50 units can be attached and the number can rise up to 80 with the skill 'Administration'. Units with the special 'Freedom' cannot be attached to any hero."),
		player_heroes[0]
	);
}