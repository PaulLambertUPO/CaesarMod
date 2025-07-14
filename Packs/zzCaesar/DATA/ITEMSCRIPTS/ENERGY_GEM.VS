//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army;
	int i, interval;

	interval = GetConst("HealthDropIvl");

	while (1) {
		Sleep(interval);

		army = .army;
		for (i = 0; i < army.count; i += 1)
			army[i].HealStamina(1);
	}
}