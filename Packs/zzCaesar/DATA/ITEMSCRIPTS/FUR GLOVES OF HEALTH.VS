//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int health_to_give;

	health_to_give = .health - .maxhealth / 10;//owner needs at least 1 health more than 10% maximum health in order to use the item

	if (health_to_give > 0) {
		ObjList ol;

		if (.InHolder) {
			ol = .GetUnitsInSameHolder();
			ol.Remove(this);
		}
		else
			ol = ObjsInSight(this, "Unit").GetObjList();

		ol.ClearDead();

		if (ol.count > 0) {
			Unit u;
			int i;

			//make 5 attempts to heal an ally chosen randomly, then in order
			for (i = 0; i < 5; i += 1) {
				u = ol[rand(ol.count)].AsUnit();
				if (u.IsValid)
					if (!.IsEnemy(u))
						if (u.health < u.maxhealth) {
							int health_to_take, heal_damage;
							health_to_take = u.maxhealth - u.health;
							heal_damage = MIN(health_to_take, health_to_give);
							u.Heal(heal_damage);
							if (!u.InHolder)
								CreateFeedback("Heal", u);
							.Damage(heal_damage);
							if (!.InHolder)
								CreateFeedback("Damage1", this);
							return;
						}
			}
			for (i = 0; i < ol.count; i += 1) {
				u = ol[i].AsUnit();
				if (u.IsValid)
					if (!.IsEnemy(u))
						if (u.health < u.maxhealth) {
							int health_to_take, heal_damage;
							health_to_take = u.maxhealth - u.health;
							heal_damage = MIN(health_to_take, health_to_give);
							u.Heal(heal_damage);
							if (!u.InHolder)
								CreateFeedback("Heal", u);
							.Damage(heal_damage);
							if (!.InHolder)
								CreateFeedback("Damage1", this);
							return;
						}
			}
		}
	}
}