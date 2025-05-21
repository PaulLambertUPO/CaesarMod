//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	while (1) {
		Sleep(1000);
		if (.IsValid)
			if (.health < .maxhealth)
				.Heal(2);
	}