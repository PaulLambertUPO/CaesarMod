//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army, army_added;
	int i;

	army = .army;
	for (i = 0; i < army.count; i += 1)
		army[i].AsUnit().AddBonus(0, 4, 4, 0, 0);
	army_added = army;

	while (1) {
		Sleep(10);

		for (i = 0; i < army.count; i += 1)//remove bonus to detached units
			if (army[i].AsUnit().hero != this)
				army[i].AsUnit().RemoveBonus(0, 4, 4, 0, 0);
		army = .army;

		for (i = 0; i < army.count; i += 1)
			if (!army_added.Contains(army[i]))
				army[i].AsUnit().AddBonus(0, 4, 4, 0, 0);
		army_added = army;
	}
}