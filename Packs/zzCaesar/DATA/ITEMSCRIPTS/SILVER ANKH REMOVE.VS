//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army;
	int i;

	army = .army;
	for (i = 0; i < army.count; i += 1)
		army[i].AsUnit().RemoveBonus(0, 4, 4, 0, 0);
}