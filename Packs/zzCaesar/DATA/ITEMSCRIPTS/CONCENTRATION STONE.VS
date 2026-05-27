//void, Obj owner, Obj target

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (!.InHolder) {
		if (target != this)
			if (target.AsUnit().IsValid)
				if (!.IsEnemy(target))
					if (.DistTo(target) <= .sight * 3 / 2) {//more range because it targets allies
						int i;

						i = .maxhealth - .health;

						if (i > 0) {
							if (target.AsHero().IsValid)
								i = MIN(i, target.health - target.maxhealth / 5);//allied heroes cannot go below 20%
							else
								i = MIN(i, target.health);

							if (i > 0) {
								target.Damage(i);
								CreateFeedback("Damage1", target.AsUnit());
								.Heal(i);
								CreateFeedback("Heal", this);
							}
						}
					}
					else
						UserNotification("target not in range", "", .pos, .player);
				else
					UserNotification("friendly target only", "", .pos, .player);
			else
				UserNotification("unit target only", "", .pos, .player);
	}
	else
		UserNotification("item cannot use in holder", "", .posRH, .player);