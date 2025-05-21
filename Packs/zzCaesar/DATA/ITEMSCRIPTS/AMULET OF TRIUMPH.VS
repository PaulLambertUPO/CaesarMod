//void, Obj owner, Obj victim

if (owner.IsValid)
	if (owner.health < owner.maxhealth) {
		owner.Heal(100);
		if (rand(2) == 0)
			owner.Heal(50);
		CreateFeedback("Heal", owner.AsUnit());
	}