//void, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(curse))
			if (target != this) {
				Unit u;

				u = target.AsUnit();

				if (u.IsValid)
					if (!u.AsShip().IsValid) {
						int stamina_cost;

						stamina_cost = GetCmdStaminaCost("curse");

						while (u.IsAlive) {
							if (!u.IsCursed)
								if (.IsEnemy(u))
									if (!u.InHolder)
										if (.CanSee(u)) {
											if (.InRange(u))
												if (.stamina >= stamina_cost) {
													.StartAnim(17, u.pos);

													Sleep(.TimeToActionMoment);

													if (u.IsAlive)
														if (!u.IsCursed)
															if (.IsEnemy(u))
																if (!u.InHolder)
																	if (.CanSee(u))
																		if (.stamina >= stamina_cost) {
																			.SetLastAttackTime();
																			if (!.IsVisible)
																				.SetVisible(true);
																			.SetStamina(.stamina - stamina_cost);
																			u.Curse();
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