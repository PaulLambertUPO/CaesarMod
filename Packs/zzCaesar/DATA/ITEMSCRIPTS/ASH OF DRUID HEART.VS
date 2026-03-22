//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	ObjList ol;
	Obj o;
	int allies_healed;

	if (.health < .maxhealth) {
		.Heal(.maxhealth);
		CreateFeedback("Heal", this);
	}

	if (.InHolder) {
		ol = .GetUnitsInSameHolder();
		ol.Remove(this);
	}
	else
		ol = ObjsInSight(this, "Unit").GetObjList();

	while (ol.count > 0) {
		o = ol[rand(ol.count)];
		if (o.IsAlive)
			if (o.health < o.maxhealth)
				if (!.IsEnemy(o)) {
					o.Heal(o.maxhealth);
					CreateFeedback("Heal", o.AsUnit());
					allies_healed += 1;
					if (allies_healed >= 8)
						break;
				}
		ol.Remove(o);
	}

	ItemUsed(1);
}