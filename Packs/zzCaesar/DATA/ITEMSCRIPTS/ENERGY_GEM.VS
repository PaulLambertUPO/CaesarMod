//void, Obj owner

Hero this;

this = owner.AsHero();

if (.IsValid) {
	ObjList army;
	Obj o;
	int i;

	while (1) {
		Sleep(15000);
		army = .army;
		for (i = army.count - 1; i >= 0; i -= 1) {
			o = army[i];
			if (o.IsAlive)
				o.HealStamina(1);
		}
	}
}