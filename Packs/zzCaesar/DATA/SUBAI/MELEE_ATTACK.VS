//void, Obj me, Obj u

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (u.IsValid)
		if (.IsEnemy(u))
			if (.IsValidTarget(u)) {
				while (!.GotoAttack(u, 5000, true, 2500)) {
					if (u.IsDead)
						return;
					if (!.IsEnemy(u))
						return;
					if (u.AsUnit().IsValid)
						if (u.AsUnit().InHolder)
							return;
				}

				if (u.IsAlive)
					if (.IsEnemy(u))
						if (u.AsCatapult().IsValid) {
							while (.Attack(u))
								if (.HasSpecial(trample))
									u.Damage(.damage);
						}
						else if (u.AsUnit().IsValid)
							if (!u.AsUnit().InHolder)
								while (.Attack(u))
									;

				.AddCommand(true, "engage");
			}