//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	while (1) {
		Sleep(1000);
		if (.IsValid)
			if (.health < .maxhealth / 4) {
				.Heal(10);
				if (!.InHolder)
					CreateFeedback("Heal", this);
			}
	}