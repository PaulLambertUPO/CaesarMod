//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (!.InHolder) {
		if (.health > .maxhealth / 5) {//owner needs at least 1 health more than 20% maximum health in order to use the item
			ObjList ol;

			ol = Subtract(ObjsInSight(this, "Unit"), Union(ObjsInSight(this, "Hen"), ObjsInSight(this, "PeasantAmbient"))).GetObjList();
			ol.ClearDead();

			if (ol.count > 0) {
				Unit u;
				int i, self_damage, out_damage, enemies_damaged;

				self_damage = MIN(.health - .maxhealth / 5, .maxhealth / 10);
				out_damage = MAX(1, self_damage / 2);

				//make 25 attempts to damage 6 enemies chosen randomly, then in order
				for (i = 0; ol.count > 0 && i < 25 && enemies_damaged < 6; i += 1) {
					u = ol[rand(ol.count)].AsUnit();
					if (u.IsValid)
						if (.IsEnemy(u))
							if (!u.AsHero().IsValid) {
								enemies_damaged += 1;
								u.Damage(out_damage);
								CreateFeedback("Lightning", u);
								ol.Remove(u);//avoid damaging the same unit more than once
							}
				}
				for (i = 0; i < ol.count && enemies_damaged < 6; i += 1) {
					u = ol[i].AsUnit();
					if (u.IsValid)
						if (.IsEnemy(u))
							if (!u.AsHero().IsValid) {
								enemies_damaged += 1;
								u.Damage(out_damage);
								CreateFeedback("Lightning", u);
							}
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
		UserNotification("item cannot use in holder", "", owner.posRH, owner.player);