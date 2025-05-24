//void, Obj owner

Unit this;

this = owner.AsUnit();

if (!.InHolder) {
	ObjList units_in_sight, units_enraged;
	Unit u;
	int i, time;

	ItemUsed(1);

	units_in_sight = ObjsInSight(this, "Military").GetObjList();
	units_in_sight.Add(this);
	units_in_sight.ClearDead();

	for (i = 0; i < units_in_sight.count; i += 1) {
		u = units_in_sight[i].AsUnit();
		if (u.IsValid)
			if (!.IsEnemy(u)) {
				u.AddBonus(30, 0, 0, 0, 0);
				units_enraged.Add(u);
			}
	}

	while (time < 5000) {
		for (i = 0; i < units_enraged.count; i += 1) {
			u = units_enraged[i].AsUnit();
			if (u.IsValid)
				if (!u.IsDead())
					if (!u.InHolder)//units in sight are not in holder, but they might enter a building during the bonus time
						if (u.radius < 30)
							CreateFeedback("Frenzy", u);
						else
							CreateFeedback("Frenzy2", u);
		}
		time += 250;
		Sleep(250);
	}

	units_enraged.ClearDead();
	for (i = 0; i < units_enraged.count; i += 1) {
		u = units_enraged[i].AsUnit();
		if (u.IsValid)
			u.RemoveBonus(30, 0, 0, 0, 0);
	}
}
else
	UserNotification("item cannot use in holder", "", owner.posRH, owner.player);