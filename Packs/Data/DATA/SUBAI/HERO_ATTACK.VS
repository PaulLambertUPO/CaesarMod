//void, Obj This, Obj target

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		if (target.IsAlive) {
			Unit u;
			bool target_catapult = false;

			u = target.AsUnit();

			if (u.IsValid) {
				if (u.InHolder) {
					.AddCommand(true, "engage");
					Sleep(30);//prevent possible loops with other commands
					return;
				}
			}
			else if (target.AsCatapult().IsValid)
				target_catapult = true;

			.FormSetupAndMoveTo(target.pos, 0, 0, true);

			if (!.IsArmyOutside)
				.FormKeepMoving(750);

			if (target.IsAlive) {
				if (u.IsValid)
					if (u.InHolder) {
						.AddCommand(true, "engage");
						Sleep(30);//prevent possible loops with other commands
						return;
					}

				if (.DistTo(target) >= .sight + 100)
					while (.HasPath) {
						.FormKeepMoving(1500);
						if (target.IsDead)
							break;
						if (u.IsValid)
							if (u.InHolder) {
								.AddCommand(true, "engage");
								Sleep(30);//prevent possible loops with other commands
								return;
							}
						if (.DistTo(target) < .sight + 100)
							break;
						.FormSetupAndMoveTo(target.pos, 0, 0, true);
					}

				if (target.IsAlive) {
					bool melee;

					if (u.IsValid)
						if (u.InHolder) {
							.AddCommand(true, "engage");
							Sleep(30);//prevent possible loops with other commands
							return;
						}

					melee = !.IsRanged;

					{
						ObjList h_army;
						Obj o;
						int i;

						h_army = .army;

						for (i = h_army.count - 1; i >= 0; i -= 1) {
							o = h_army[i];
							if (o.IsAlive)
								if (target_catapult)
									if (o.IsMilitary)
										o.SetCommand("attack", target);
									else
										o.SetCommand("engage");
								else if (o.IsRanged)
									o.SetCommand("attack", target);
								else
									o.SetCommand("engage");
						}
					}

					while (.IsValidTarget(target)) {
						if (u.IsValid)
							if (u.InHolder)
								break;
						if (.GotoAttack(target, 1500, true, 3000))
							if (.IsValidTarget(target))
								if (target_catapult) {
									while (.Attack(target))
										if (melee)
											if (.HasSpecial(trample))
												target.Damage(.damage);
								}
								else
									while (.Attack(target))
										;
					}
				}
			}
		}

		.AddCommand(true, "engage");
	}

Sleep(30);//prevent possible loops with other commands