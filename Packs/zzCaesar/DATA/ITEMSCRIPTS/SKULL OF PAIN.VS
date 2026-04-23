//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (!.InHolder) {
		if (.health > .maxhealth / 5) {
			ObjList ol;

			ol = VisibleObjsInSight(this, "Unit").GetObjList();

			if (ol.count > 0) {
				Obj o;
				int self_damage, out_damage, enemies_damaged;

				self_damage = MIN(.health - .maxhealth / 5, .maxhealth / 10);
				out_damage = MAX(1, self_damage / 2);

				while (ol.count > 0) {
					o = ol[rand(ol.count)];
					if (o.IsAlive)
						if (.IsEnemy(o))
							if (!o.AsHero().IsValid)
								if (!o.IsPeasantAmbient)
									if (!o.IsHeirOf("Hen")) {
										o.Damage(out_damage);
										CreateFeedback("Lightning", o.AsUnit());
										enemies_damaged += 1;
										if (enemies_damaged >= 6)
											break;
									}
					ol.Remove(o);
				}

				if (enemies_damaged > 0) {
					.Damage(self_damage);
					CreateFeedback("Damage2", this);
				}

				Sleep(3000);//cooldown
			}
		}
	}
	else
		UserNotification("item cannot use in holder", "", .posRH, .player);