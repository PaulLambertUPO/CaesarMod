//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int food_to_distribute, give;

	food_to_distribute = GetUseCount();

	if (.food < .maxfood) {
		give = MIN(food_to_distribute, .maxfood - .food);
		food_to_distribute -= give;
		.SetFood(.food + give);
	}

	if (food_to_distribute > 0) {
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

		for (i = 0; i < ol.count && food_to_distribute > 0; i += 1) {
			u = ol[i].AsUnit();
			if (u.IsValid)
				if (u.food < u.maxfood)
					if (!.IsEnemy(u)) {
						give = MIN(food_to_distribute, u.maxfood - u.food);
						food_to_distribute -= give;
						u.SetFood(u.food + give);
					}
		}
	}

	ItemUsed(GetUseCount() - food_to_distribute);
}