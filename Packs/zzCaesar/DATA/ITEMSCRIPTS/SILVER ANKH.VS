//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army, army_added;
	int i;

	while (1) {
		army = .army;
		for (i = 0; i < army.count; i += 1)
			if (!army_added.Contains(army[i])) {
				army[i].AsUnit().AddBonus(0, 4, 4, 0, 0);
				army_added.Add(army[i]);
			}

		army_added.ClearDead();
		for (i = army_added.count - 1; i >= 0; i -= 1)//remove bonus from detached units
			if (army_added[i].AsUnit().hero != this) {
				army_added[i].AsUnit().RemoveBonus(0, 4, 4, 0, 0);
				army_added.Remove(army_added[i]);
			}

		Sleep(50);
	}
}