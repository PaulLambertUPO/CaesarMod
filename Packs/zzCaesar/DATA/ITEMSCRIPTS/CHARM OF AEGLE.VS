//void, Obj owner

if (owner.AsUnit().IsValid)
	while (true) {
		Sleep(1000);
		if (owner.health < owner.maxhealth)
			owner.Heal(2);
	}