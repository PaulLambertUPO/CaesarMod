ObjList enemy_heroes;
Unit u;
int i;

while (1) {
	enemy_heroes = GetPlayerUnits(2, cHero);
	enemy_heroes.AddList(GetPlayerUnits(3, cHero));
	enemy_heroes.ClearDead();
	for (i = 0; i < enemy_heroes.count; i += 1) {
		u = enemy_heroes[i].AsUnit();
		if (u.IsValid) {
			if (!u.HasItem("Scroll of Death"))
				u.AddItem("Scroll of Death");
			if (!u.HasItem("Scroll of Life"))
				u.AddItem("Scroll of Life");
		}
	}
	Sleep(60000);
}