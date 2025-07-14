//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int health_to_distribute, give;

	health_to_distribute = GetUseCount();

	if (.health < .maxhealth) {
		give = MIN(health_to_distribute, .maxhealth - .health);
		health_to_distribute -= give;
		.Heal(give);
		if (!.InHolder)
			CreateFeedback("Heal", this);
	}

	if (health_to_distribute > 0) {
		ObjList ol;
		Unit u;
		int i;

		if (.InHolder) {
			ol = .GetUnitsInSameHolder();
			ol.Remove(this);
		}
		else
			ol = ObjsInSight(this, "Unit").GetObjList();

		ol.ClearDead();

		for (i = 0; i < ol.count && health_to_distribute > 0; i += 1) {
			u = ol[i].AsUnit();
			if (u.IsValid)
				if (u.health < u.maxhealth)
					if (!.IsEnemy(u)) {
						give = MIN(health_to_distribute, u.maxhealth - u.health);
						health_to_distribute -= give;
						u.Heal(give);
						if (!u.InHolder)
							CreateFeedback("Heal", u);
					}
		}
	}

	ItemUsed(GetUseCount() - health_to_distribute);
}