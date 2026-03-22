//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int i;

	i = .health - .maxhealth / 10;//owner needs at least 1 health more than 10% maximum health in order to use the item

	if (i > 0) {
		ObjList ol;

		if (.InHolder) {
			ol = .GetUnitsInSameHolder();
			ol.Remove(this);
		}
		else
			ol = ObjsInSight(this, "Unit").GetObjList();

		if (ol.count > 0) {
			Obj o;

			while (ol.count > 0) {
				o = ol[rand(ol.count)];
				if (o.IsAlive)
					if (o.health < o.maxhealth)
						if (!.IsEnemy(o)) {
							i = MIN(i, o.maxhealth - o.health);
							.Damage(i);
							CreateFeedback("Damage1", this);
							o.Heal(i);
							CreateFeedback("Heal", o.AsUnit());
							return;
						}
				ol.Remove(o);
			}
		}
	}
}