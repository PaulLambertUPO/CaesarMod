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
			o.AsUnit().RemoveBonus(0, 4, 4, 0, 0);
	}
}