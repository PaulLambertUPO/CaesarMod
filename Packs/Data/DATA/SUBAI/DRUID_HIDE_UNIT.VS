//void, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(invisibility)) {
			Unit u;

			u = target.AsUnit();

			if (u.IsValid)
				if (!u.IsWaterUnit)
					if (!u.IsSentry)
						if (!u.IsPeasantAmbient)
							if (!u.IsRam) {
								str cmd;
								int stamina_cost;

								stamina_cost = GetCmdStaminaCost("hide");

								while (u.IsAlive) {
									if (u.IsVisible)
										if (!.IsEnemy(u))
											if (!u.InHolder)
												if (.CanSee(u)) {
													if (.InRange(u))
														if (.stamina >= stamina_cost) {
															.StartAnim(17, u.pos);

															Sleep(.TimeToActionMoment);

															if (u.IsAlive)
																if (u.IsVisible)
																	if (!.IsEnemy(u))
																		if (!u.InHolder)
																			if (.CanSee(u))
																				if (.stamina >= stamina_cost) {
																					.SetLastAttackTime();
																					.SetStamina(.stamina - stamina_cost);
																					u.SetVisible(false);
																					if (u.IsMilitary) {
																						cmd = u.command;
																						if (cmd == "engage")
																							u.KillCommand();
																						else if (cmd == "attack")
																							u.KillCommand();
																						else if (cmd != "capture")
																							if (u.TimeWithoutAttack < 2000)//other fight commands
																								u.KillCommand();
																					}
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