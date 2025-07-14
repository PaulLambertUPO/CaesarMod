//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army, army_added;
	int i;

	while (1) {
		army = .army;
		for (i = 0; i < army.count; i += 1)
			if (army[i].IsMilitary)//do not give the bonus to other units to avoid displaying a value if they are selected
				if (!army_added.Contains(army[i])) {
					army[i].AsUnit().AddBonus(4, 0, 0, 0, 0);
					army_added.Add(army[i]);
				}

		army_added.ClearDead();
		for (i = army_added.count - 1; i >= 0; i -= 1)
			if (army_added[i].AsUnit().hero != this) {//remove bonus from detached units
				army_added[i].AsUnit().RemoveBonus(4, 0, 0, 0, 0);
				army_added.Remove(army_added[i]);
			}
			else if (!army_added[i].IsMilitary) {//remove bonus from militiamen converted to peasants
				army_added[i].AsUnit().RemoveBonus(4, 0, 0, 0, 0);
				army_added.Remove(army_added[i]);
			}

		Sleep(50);
	}
}