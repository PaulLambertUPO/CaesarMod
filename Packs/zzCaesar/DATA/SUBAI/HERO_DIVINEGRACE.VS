//void, Obj this

if (.AsHero().IsValid)
	if (.IsAlive)
		if (.health < .maxhealth) {
			int cost;

			cost = cmdcost_stamina;

			if (.stamina >= cost) {
				.SetStamina(.stamina - cost);
				.Heal(100);
				CreateFeedback("Heal", .AsUnit());
			}
		}