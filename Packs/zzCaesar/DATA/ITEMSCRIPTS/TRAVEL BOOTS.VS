//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	ObjList army;
	Hero h;
	Obj o;
	int i;
	bool is_hero;

	h = .AsHero();
	is_hero = h.IsValid;

	while (1) {
		Sleep(500);

		.Heal(1);

		if (is_hero) {
			army = h.army;
			for (i = army.count - 1; i >= 0; i -= 1) {
				o = army[i];
				if (o.IsAlive)
					o.Heal(1);
			}
		}
	}
}