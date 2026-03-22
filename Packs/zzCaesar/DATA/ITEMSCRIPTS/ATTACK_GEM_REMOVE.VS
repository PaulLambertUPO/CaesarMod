//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army;
	Obj o;
	int i;

	army = .army;

	for (i = army.count - 1; i >= 0; i -= 1) {
		o = army[i];
		if (o.IsAlive)
			if (o.IsMilitary)
				o.AsUnit().RemoveBonus(4, 0, 0, 0, 0);
			else if (o.IsPeasant)//peasants can be attached only via militiaman conversion
				o.AsUnit().RemoveBonus(4, 0, 0, 0, 0);
	}
}