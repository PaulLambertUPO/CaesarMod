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
					if (o.IsMilitary) {//do not give the bonus to other units to avoid displaying a damage value in the interface if they are selected
						o.AsUnit().AddBonus(4, 0, 0, 0, 0);
						CreateFeedback("OffensiveTactics", o.AsUnit());
					}
					army_added.Add(o);
				}
		}

		for (i = army_added.count - 1; i >= 0; i -= 1) {//remove bonus from detached units and militiamen converted to peasants
			o = army_added[i];
			if (o.IsDead)
				army_added.Remove(o);
			else if (o.AsUnit().hero != this) {
				if (o.IsMilitary)
					o.AsUnit().RemoveBonus(4, 0, 0, 0, 0);
				else if (o.IsPeasant)
					o.AsUnit().RemoveBonus(4, 0, 0, 0, 0);
				army_added.Remove(o);
			}
			else if (o.IsPeasant) {
				o.AsUnit().RemoveBonus(4, 0, 0, 0, 0);
				army_added.Remove(o);
			}
		}

		Sleep(500);
	}
}