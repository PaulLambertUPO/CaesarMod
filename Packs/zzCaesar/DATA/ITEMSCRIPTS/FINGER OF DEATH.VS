//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (!.InHolder) {
		ObjList ol, ol_killed;
		Obj o;

		ol = VisibleObjsInSight(this, "Unit").GetObjList();

		while (ol.count > 0) {
			o = ol[rand(ol.count)];
			if (o.IsAlive)
				if (.IsEnemy(o))
					if (!o.AsHero().IsValid)
						if (!o.IsPeasantAmbient)
							if (!o.IsHeirOf("Hen")) {
								ol_killed.Add(o);
								if (ol_killed.count >= 4)
									break;
							}
			ol.Remove(o);
		}

		if (ol_killed.count > 0) {
			int i;

			ItemUsed(1);//done here because if the owner dies during the sleeps the use counter will not decrement unless it is the last one (which could lead to exploits)

			for (i = ol_killed.count - 1; i >= 0; i -= 1) {
				o = ol_killed[i];
				if (o.IsAlive) {
					CreateFeedback("Lightning2", o.AsUnit());
					Sleep(500);
					o.Damage(o.health);
				}
			}
		}

		Sleep(3000);//cooldown
	}
	else
		UserNotification("item cannot use in holder", "", .posRH, .player);