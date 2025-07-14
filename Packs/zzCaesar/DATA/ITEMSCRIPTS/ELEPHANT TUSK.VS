//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	while (1) {
		Sleep(1000);
		if (.health < .maxhealth)
			.Heal(25);
	}