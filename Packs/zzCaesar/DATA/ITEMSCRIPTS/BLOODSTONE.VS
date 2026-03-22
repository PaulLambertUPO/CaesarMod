//void, Obj owner, Obj target

if (GetUseCount() <= 0) {
	Unit this;

	this = owner.AsUnit();

	if (.IsValid)
		if (!.InHolder)
			if (target.AsUnit().IsValid)
				if (.IsEnemy(target))
					if (.DistTo(target) <= .sight) {
						int i;

						i = .maxhealth - .health;

						if (i > 0) {
							if (target.AsHero().IsValid)
								i = MIN(i, target.health - target.maxhealth / 2);//enemy heroes cannot go below 50%
							else
								i = MIN(i, target.health);

							if (i > 0) {
								Item item;

								target.Damage(i);
								CreateFeedback("Damage1", target.AsUnit());
								.Heal(i);
								CreateFeedback("Heal", this);

								for (i = .items_count; i >= 1; i -= 1) {
									item = .GetItem(i);
									if (item.IsValid)
										if (item.name == "Bloodstone")
											item.SetUseCount(30);
								}
							}
						}
					}
					else
						UserNotification("target not in range", "", .pos, .player);
				else
					UserNotification("enemy target only", "", .pos, .player);
			else
				UserNotification("unit target only", "", .pos, .player);
		else
			UserNotification("item cannot use in holder", "", .posRH, .player);
}