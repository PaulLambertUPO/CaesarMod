//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int charges;

	while (true) {
		Sleep(1000);

		charges = GetUseCount();

		if (.health < .maxhealth)
			if (charges < 25)
				SetUseCount(charges + 5);
			else {
				SetUseCount(charges - 20);
				.Heal(20);
				CreateFeedback("Heal", this);
			}
		else if (charges < 600)
			SetUseCount(charges + 5);
	}
}