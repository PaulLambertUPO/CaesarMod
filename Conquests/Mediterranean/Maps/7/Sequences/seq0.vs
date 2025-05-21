ObjList enemy_heroes;
Unit u;
int i;

while (1) {
	Sleep(60000);
	enemy_heroes = GetPlayerUnits(2, cHero);
	enemy_heroes.AddList(GetPlayerUnits(3, cHero));
	enemy_heroes.ClearDead();
	for (i = 0; i < enemy_heroes.count; i += 1) {
		u = enemy_heroes[i].AsUnit();
		if (u.IsValid)
			if (u.inherentlevel < 24) {
				u.SetLevel(u.inherentlevel + 1);
				if (!u.InHolder())
					CreateFeedback("Experience", u);
			}
	}
}