//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	Hero h;
	ObjList army;
	bool is_hero;
	int i;

	h = .AsHero();
	is_hero = h.IsValid;

	while (1) {
		Sleep(500);
		if (.health < .maxhealth)
			.Heal(1);
		if (is_hero) {
			army = h.army;
			for (i = 0; i < army.count; i += 1)
				army[i].Heal(1);
		}
	}
}