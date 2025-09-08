//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int charges;

	while (1) {
		Sleep(1000);
		if (.health >= .maxhealth)
			charges = MIN(600, GetUseCount() + 5);
		else {
			charges = GetUseCount();
			if (charges < 25)
				charges = MIN(600, charges + 5);
			else {
				charges -= 20;
				.Heal(20);
				if (!.InHolder)
					CreateFeedback("Heal", this);
			}
		}
		ItemUsed(GetUseCount() - charges);
	}
}