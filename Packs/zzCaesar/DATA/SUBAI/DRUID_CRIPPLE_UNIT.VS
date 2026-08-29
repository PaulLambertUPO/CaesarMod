//void, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(cripple))
			if (target != this) {
				Unit u;

				u = target.AsUnit();

				if (u.IsValid)
					if (!target.AsHero().IsValid)
						if (!u.AsShip().IsValid)
							if (!u.IsRam) {
								int stamina_cost;

								stamina_cost = GetCmdStaminaCost("cripple");

								while (u.IsAlive) {
									if (u.stamina > 0)
										if (.IsEnemy(u))
											if (!u.InHolder)
												if (.CanSee(u)) {
													if (.InRange(u))
														if (.stamina >= stamina_cost) {
															.StartAnim(17, u.pos);

															Sleep(.TimeToActionMoment);

															if (u.IsAlive)
																if (u.stamina > 0)
																	if (.IsEnemy(u))
																		if (!u.InHolder)
																			if (.CanSee(u))
																				if (.stamina >= stamina_cost) {
																					.SetLastAttackTime();
																					if (!.IsVisible)
																						.SetVisible(true);
																					.SetStamina(.stamina - stamina_cost);
																					u.SetStamina(0);
																					CreateFeedback("StaminaLoss", u);
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

Sleep(30);//prevent possible loops with other commands