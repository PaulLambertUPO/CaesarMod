//void, Obj me

Hero this;

this = me.AsHero();

if (.IsValid)
	if (.stamina >= cmdcost_stamina)
		if (.health < .maxhealth) {
			if (!.InHolder)
				CreateFeedback("Heal", this);
			.SetStamina(.stamina - cmdcost_stamina);
			.Heal(100);
		}