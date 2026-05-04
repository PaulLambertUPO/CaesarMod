//void, Obj This, Obj target

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Unit u;

		u = target.AsUnit();

		if (u.IsValid) {
			if (.IsValidTarget(u))
				if (!u.InHolder) {
					.FormSetupAndMoveTo(u.pos, 0, 0, true);

					if (!.IsArmyOutside)
						.FormKeepMoving(750);

					if (u.IsAlive)
						if (!u.InHolder) {
							if (.DistTo(u) >= .sight + 100)
								while (.HasPath) {
									.FormKeepMoving(1500);
									if (u.IsDead)
										break;
									if (u.InHolder)
										break;
									if (.DistTo(u) < .sight + 100)
										break;
									.FormSetupAndMoveTo(u.pos, 0, 0, true);
								}

							if (u.IsAlive)
								if (!u.InHolder) {
									{
										ObjList h_army;
										Obj o;
										int i;

										h_army = .army;
										for (i = h_army.count - 1; i >= 0; i -= 1) {
											o = h_army[i];
											if (o.IsAlive)
												if (o.IsRanged)
													o.SetCommand("attack_unit_type_exclusive", u);
												else
													o.SetCommand("engage_unit_type_exclusive", u);
										}
									}

									while (.IsValidTarget(u)) {
										if (u.InHolder)
											break;
										if (.GotoAttack(u, 1500, true, 3000))
											if (.IsValidTarget(u))
												while (.Attack(u))
													;
									}
								}
						}
				}

			.AddCommand(true, "engage_unit_type_exclusive", target);//using u is not good because it might be invalid after the loops
		}
		else
			.AddCommand(true, "engage");
	}

Sleep(30);//prevent possible loops with other commands