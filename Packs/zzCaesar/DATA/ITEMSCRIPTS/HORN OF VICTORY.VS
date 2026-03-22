//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (!.InHolder) {
		ObjList ol;
		Obj o;
		int i, enemies_damaged;

		ol = VisibleObjsInSight(this, "Unit").GetObjList();

		while (ol.count > 0) {
			o = ol[rand(ol.count)];
			if (o.IsAlive)
				if (.IsEnemy(o))
					if (!o.IsPeasantAmbient)
						if (!o.IsHeirOf("Hen")) {
							o.Damage(75);
							CreateFeedback("Damage2", o.AsUnit());
							enemies_damaged += 1;
							if (enemies_damaged >= 15)
								break;
						}
			ol.Remove(o);
		}

		if (enemies_damaged > 0)
			ItemUsed(1);

		Sleep(1000);//cooldown
	}
	else
		UserNotification("item cannot use in holder", "", .posRH, .player);