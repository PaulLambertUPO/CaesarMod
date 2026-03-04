//void, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(healing))
			if (target != this) {
				Unit u;

				u = target.AsUnit();

				if (u.IsValid)
					if (!u.AsShip().IsValid)
						if (!u.IsRam) {
							int heal_amount, stamina_cost;

							heal_amount = GetConst("HealAmount");
							stamina_cost = GetCmdStaminaCost("heal");

							while (u.IsAlive) {
								if (u.health < u.maxhealth)
									if (!.IsEnemy(u))
										if (!u.InHolder)
											if (.CanSee(u)) {
												if (.InRange(u))
													if (.stamina >= stamina_cost) {
														.StartAnim(17, u.pos);

														Sleep(.TimeToActionMoment);

														if (u.IsAlive)
															if (u.health < u.maxhealth)
																if (!.IsEnemy(u))
																	if (!u.InHolder)
																		if (.CanSee(u))
																			if (.stamina >= stamina_cost) {
																				.SetLastAttackTime();
																				if (!.IsVisible)
																					.SetVisible(true);
																				.SetStamina(.stamina - stamina_cost);
																				u.Heal(heal_amount + .level);
																				CreateFeedback("Heal", u);
																			}

														Sleep(.TimeToAnimFinish);
													}
													else
														Sleep(500);
												else
													.GotoAttack(u, 2000, false, 2500);

												continue;
											}
								break;
							}
						}
			}

Sleep(15);//prevent possible loops with other commands