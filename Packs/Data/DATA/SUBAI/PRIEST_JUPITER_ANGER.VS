//void, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (target != this) {
			Unit u;

			u = target.AsUnit();

			if (u.IsValid)
				if (u.IsAlive)
					if (!u.InHolder)
						if (.CanSee(u)) {
							while (!.GotoAttack(u, 5000, false, 0)) {
								if (u.IsDead)
									return;
								if (u.InHolder)
									return;
								if (.InRange(u))
									break;
								if (!.CanSee(u))
									break;
							}

							if (u.IsAlive)
								if (!u.InHolder)
									if (.CanSee(u)) {//do not kill for consistency with "unit_on_kill.vs"
										CreateFeedback("Lightning3", u);
										if (u.AsHero())
											u.Damage(MIN(40, u.health - 1));
										else
											u.Damage(MIN(250, u.health - 1));
										.Damage(.health);
									}
						}
		}