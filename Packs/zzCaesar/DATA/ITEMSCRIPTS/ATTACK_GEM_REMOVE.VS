//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army;
	int i;

	army = .army;
	for (i = 0; i < army.count; i += 1)
		if (army[i].IsMilitary)
			army[i].AsUnit().RemoveBonus(4, 0, 0, 0, 0);
		else if (army[i].IsPeasant)//peasants can be attached only through militiaman conversion
			army[i].AsUnit().RemoveBonus(4, 0, 0, 0, 0);
}