//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	bool bonus_gained = false;

	while (true) {
		Sleep(500);
		if (bonus_gained) {
			if (.TimeWithoutAttack > 3000) {
				.SetSpeedFactor(100);
				bonus_gained = false;
			}
		}
		else if (.TimeWithoutAttack <= 3000) {
			.SetSpeedFactor(140);
			bonus_gained = true;
		}
	}
}