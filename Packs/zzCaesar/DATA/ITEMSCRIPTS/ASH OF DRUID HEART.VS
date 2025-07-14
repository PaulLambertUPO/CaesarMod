//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	ObjList ol;
	Unit u;
	int i, allies_healed;

	if (.InHolder) {
		ol = .GetUnitsInSameHolder();
		ol.Remove(this);
	}
	else
		ol = ObjsInSight(this, "Unit").GetObjList();

	if (.health < .maxhealth) {
		.Heal(.maxhealth);
		if (!.InHolder)
			CreateFeedback("Heal", this);
	}

	ol.ClearDead();

	//make 25 attempts to heal 8 allies chosen randomly, then in order
	for (i = 0; ol.count > 0 && i < 25 && allies_healed < 8; i += 1) {
		u = ol[rand(ol.count)].AsUnit();
		if (u.IsValid)
			if (u.health < u.maxhealth)
				if (!.IsEnemy(u))
					if (!u.IsPeasantAmbient) {
						allies_healed += 1;
						u.Heal(u.maxhealth);
						if (!u.InHolder)
							CreateFeedback("Heal", u);
						ol.Remove(u);//avoid healing the same unit more than once
					}
	}
	for (i = 0; i < ol.count && allies_healed < 8; i += 1) {
		u = ol[i].AsUnit();
		if (u.IsValid)
			if (u.health < u.maxhealth)
				if (!.IsEnemy(u))
					if (!u.IsPeasantAmbient) {
						allies_healed += 1;
						u.Heal(u.maxhealth);
						if (!u.InHolder)
							CreateFeedback("Heal", u);
					}
	}

	ItemUsed(1);
}