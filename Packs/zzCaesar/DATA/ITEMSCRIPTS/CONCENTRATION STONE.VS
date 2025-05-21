//void, Obj owner, Obj target

if (!owner.AsUnit().InHolder)
	if (target.AsUnit().IsValid)
		if (!target.IsEnemy(owner)) {
			if (target.DistTo(owner) <= owner.sight * 3 / 2) {
				int missing_health;

				missing_health = owner.maxhealth - owner.health;

				if (missing_health > 0) {
					int health_taken;

					if (target.AsHero().IsValid)
						health_taken = target.health - target.maxhealth / 5;//allied heroes cannot go below 20%
					else
						health_taken = target.health;

					if (health_taken > 0) {
						int heal_damage;
						heal_damage = MIN(health_taken, missing_health);
						CreateFeedback("Heal", owner.AsUnit());
						owner.Heal(heal_damage);
						CreateFeedback("Damage1", target.AsUnit());
						target.Damage(heal_damage);
					}
				}
			}
		}
		else
			UserNotification("friendly target only", "", owner.posRH, owner.player);
	else
		UserNotification("unit target only", "", owner.posRH, owner.player);
else
	UserNotification("item cannot use in holder", "", owner.posRH, owner.player);