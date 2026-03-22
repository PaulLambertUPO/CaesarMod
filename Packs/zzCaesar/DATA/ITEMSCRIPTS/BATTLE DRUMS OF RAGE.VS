//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (!.InHolder) {
		ObjList units_enraged;
		Obj o;
		int i, time;

		ItemUsed(1);

		units_enraged = ObjsInCircle(.pos, .sight, "Military").GetObjList();//do not use ObjsInSight to avoid having to add the owner manually

		for (i = units_enraged.count - 1; i >= 0; i -= 1) {
			o = units_enraged[i];
			if (o.IsDead)
				units_enraged.Remove(o);
			else if (.IsEnemy(o))
				units_enraged.Remove(o);
			else
				o.AsUnit().AddBonus(30, 0, 0, 0, 0);
		}

		while (time < 10000) {
			for (i = units_enraged.count - 1; i >= 0; i -= 1) {
				o = units_enraged[i];
				if (o.IsAlive)
					if (o.radius < 30)
						CreateFeedback("Frenzy", o.AsUnit());
					else
						CreateFeedback("Frenzy2", o.AsUnit());
			}
			time += 250;
			Sleep(250);
		}

		for (i = units_enraged.count - 1; i >= 0; i -= 1) {
			o = units_enraged[i];
			if (o.IsAlive)
				o.AsUnit().RemoveBonus(30, 0, 0, 0, 0);
		}
	}
	else
		UserNotification("item cannot use in holder", "", .posRH, .player);