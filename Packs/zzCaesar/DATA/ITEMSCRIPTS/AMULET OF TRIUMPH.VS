//void, Obj owner, Obj victim

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (.health < .maxhealth) {
		.Heal(100);
		if (rand(2) == 0)
			.Heal(50);
		CreateFeedback("Heal", this);
	}