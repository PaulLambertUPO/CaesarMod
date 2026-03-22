//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int health_given, health_to_distribute;

	health_to_distribute = GetUseCount();

	if (.health < .maxhealth) {
		health_given = MIN(health_to_distribute, .maxhealth - .health);
		health_to_distribute -= health_given;
		.Heal(health_given);
		CreateFeedback("Heal", this);
	}

	if (health_to_distribute > 0) {
		ObjList ol;
		Obj o;
		int i;

		if (.InHolder) {
			ol = .GetUnitsInSameHolder();
			ol.Remove(this);
		}
		else
			ol = ObjsInSight(this, "Unit").GetObjList();

		for (i = ol.count - 1; i >= 0; i -= 1) {
			o = ol[i];
			if (o.IsAlive)
				if (o.health < o.maxhealth)
					if (!.IsEnemy(o)) {
						health_given = MIN(health_to_distribute, o.maxhealth - o.health);
						health_to_distribute -= health_given;
						o.Heal(health_given);
						CreateFeedback("Heal", o.AsUnit());
						if (health_to_distribute <= 0)
							break;
					}
		}
	}

	ItemUsed(GetUseCount() - health_to_distribute);
}