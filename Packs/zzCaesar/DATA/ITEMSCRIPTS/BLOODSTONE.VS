//void, Obj owner, Obj target

if (GetUseCount() <= 0) {
	Unit this;

	this = owner.AsUnit();

	if (.IsValid)
		if (!.InHolder)
			if (target.AsUnit().IsValid)
				if (.IsEnemy(target))
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
								Item item;
								int i;

								i = MIN(health_taken, missing_health);
								CreateFeedback("Damage1", target.AsUnit());
								target.Damage(i);
								CreateFeedback("Heal", this);
								.Heal(i);

								for (i = .item_count; i >= 1; i -= 1) {
									item = .GetItem(i);
									if (item.IsValid)
										if (item.name == "Bloodstone")
											item.SetUseCount(30);
								}
							}
						}
					}
					else
						UserNotification("target not in range", "", .posRH, .player);
				else
					UserNotification("enemy target only", "", .posRH, .player);
			else
				UserNotification("unit target only", "", .posRH, .player);
		else
			UserNotification("item cannot use in holder", "", .posRH, .player);
}