//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	int food_given, food_to_distribute;

	food_to_distribute = GetUseCount();

	if (.food < .maxfood) {
		food_given = MIN(food_to_distribute, .maxfood - .food);
		food_to_distribute -= food_given;
		.SetFood(.food + food_given);
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

		for (i = ol.count - 1; i >= 0; i -= 1) {
			u = ol[i].AsUnit();
			if (u.IsAlive)
				if (u.food < u.maxfood)
					if (!.IsEnemy(u)) {
						food_given = MIN(food_to_distribute, u.maxfood - u.food);
						food_to_distribute -= food_given;
						u.SetFood(u.food + food_given);
						if (food_to_distribute <= 0)
							break;
					}
		}
	}

	ItemUsed(GetUseCount() - food_to_distribute);
}