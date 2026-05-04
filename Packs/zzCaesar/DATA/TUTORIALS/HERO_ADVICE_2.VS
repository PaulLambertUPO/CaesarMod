//void, int playerid

//this script shows a hint about attaching units

ObjList player_heroes;
Obj o;
int i;

Sleep(90000);

player_heroes = GetPlayerUnits(playerid, cHero);

if (player_heroes.count > 0) {
	for (i = player_heroes.count - 1; i >= 0; i -= 1) {
		o = player_heroes[i];
		if (o.IsAlive)
			if (o.AsHero().HasArmy)
				return;
	}
	if (o.IsAlive)
		ShowTutorial(
			Translate("Attaching units"),
			Translate("It is possible to attach units to a hero to improve the effectiveness of an army by selecting them and right-clicking on the hero. The hero shares some experience and improves the troops with special abilities. Up to 50 units can be attached and the number can rise up to 80 with the skill 'Administration'. Units with the special 'Freedom' cannot be attached to any hero."),
			o
		);
}