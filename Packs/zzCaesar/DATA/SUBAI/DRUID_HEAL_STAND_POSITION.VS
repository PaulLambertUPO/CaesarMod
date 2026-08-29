//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Unit u;
			int heal_amount, stamina_cost, learnings;
			bool use_healing;

			Sleep(rand(501));//avoid "thundering herd" for multiple units that start the command simultaneously

			heal_amount = GetConst("HealAmount");
			stamina_cost = GetCmdStaminaCost("heal");

			while (.CmdCount <= 1)//avoid blocking pending commands forever
				if (.Stop(2000)) {
					if (.IsVisible) {
						u.Clear();
						if (.stamina >= stamina_cost)
							if (.HasSpecial(healing)) {
								use_healing = true;
								u = .FindUnitToHeal();
							}
						if (u.IsDead) {
							use_healing = false;
							u = .FindUnitToLearn();
						}

						if (u.IsAlive)
							if (u != this) {
								learnings = 0;
								while (u.IsAlive) {
									if (.IsVisible)
										if (!.IsEnemy(u))
											if (!u.InHolder)
												if (.CanSee(u))
													if (.InRange(u))
														if (use_healing) {
															if (u.health < u.maxhealth)
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
																	continue;
																}
														}
														else if (.experience < u.experience) {
															.StartAnim(19, u.pos);

															Sleep(.TimeToActionMoment);

															if (u.IsAlive)
																if (.experience < u.experience)
																	if (!.IsEnemy(u))
																		if (!u.InHolder)
																			if (.CanSee(u)) {
																				.SetLastAttackTime();
																				if (!.IsVisible)
																					.SetVisible(true);
																				.SetExperience(MIN(u.experience, .experience + (.inherentlevel + 4) / 4));
																				CreateFeedback("Experience", this);
																			}

															Sleep(.TimeToAnimFinish);
															learnings += 1;
															if (learnings < 12)
																continue;
														}
									break;
								}
							}
					}

					.Idle(1000);
				}
		}

Sleep(30);//prevent possible loops with other commands