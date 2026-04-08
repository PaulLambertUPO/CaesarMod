//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army, army_added;
	Obj o;
	int i;

	while (true) {
		army = .army;
		for (i = army.count - 1; i >= 0; i -= 1) {
			o = army[i];
			if (o.IsAlive)
				if (!army_added.Contains(o)) {
					o.AsUnit().AddBonus(0, 4, 4, 0, 0);
					CreateFeedback("DefensiveStand", o.AsUnit());
					army_added.Add(o);
				}
		}

		for (i = army_added.count - 1; i >= 0; i -= 1) {//remove bonus from detached units
			o = army_added[i];
			if (o.IsDead)
				army_added.Remove(o);
			else if (o.AsUnit().hero != this) {
				o.AsUnit().RemoveBonus(0, 4, 4, 0, 0);
				army_added.Remove(o);
			}
		}

		Sleep(500);
	}
}