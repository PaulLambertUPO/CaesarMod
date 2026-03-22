//void, Obj owner

if (owner.AsUnit().IsValid)
	while (1) {
		Sleep(1000);
		if (owner.health < owner.maxhealth)
			owner.Heal(25);
	}