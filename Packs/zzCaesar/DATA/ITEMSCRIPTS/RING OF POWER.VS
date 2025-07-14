//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int charges;

	while (1) {
		Sleep(1000);
		charges = GetUseCount();
		if (.health < .maxhealth && charges >= 25) {
			charges -= 20;
			.Heal(20);
			if (!.InHolder)
				CreateFeedback("Heal", this);
		}
		else
			charges = MIN(600, charges + 5);
		ItemUsed(GetUseCount() - charges);
	}
}