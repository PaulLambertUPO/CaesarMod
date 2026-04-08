//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	while (true) {
		Sleep(1000);
		if (.health < .maxhealth / 4) {
			.Heal(10);
			CreateFeedback("Heal", this);
		}
	}