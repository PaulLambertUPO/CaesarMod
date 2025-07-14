//void, Obj owner, Obj target

if (GetUseCount() <= 0) {
	Unit this;

	this = owner.AsUnit();

	if (.IsValid)
		if (!.InHolder)
			if (target.AsUnit().IsValid)
				if (.IsEnemy(target)) {
					if (.DistTo(target) <= .sight) {
						int missing_health;

						missing_health = .maxhealth - .health;

						if (missing_health > 0) {
							int health_taken;

							if (target.AsHero().IsValid)
								health_taken = target.health - target.maxhealth / 2;//enemy heroes cannot go below 50%
							else
								health_taken = target.health;

							if (health_taken > 0) {
								int heal_damage;
								heal_damage = MIN(health_taken, missing_health);
								CreateFeedback("Damage1", target.AsUnit());
								target.Damage(heal_damage);
								CreateFeedback("Heal", this);
								.Heal(heal_damage);
								SetUseCount(20);
							}
						}
					}
				}
				else
					UserNotification("enemy target only", "", .posRH, .player);
			else
				UserNotification("unit target only", "", .posRH, .player);
		else
			UserNotification("item cannot use in holder", "", .posRH, .player);
}