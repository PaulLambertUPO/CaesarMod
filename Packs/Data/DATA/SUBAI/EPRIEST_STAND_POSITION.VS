//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Unit u;
			int stamina_cost, learnings;
			bool use_cripple;

			Sleep(rand(501));//avoid "thundering herd" for multiple units that start the command simultaneously

			stamina_cost = GetCmdStaminaCost("cripple");

			while (.CmdCount <= 1)//avoid blocking pending commands forever
				if (.Stop(2000)) {
					if (.IsVisible) {
						u.Clear();
						if (.stamina >= stamina_cost)
							if (.HasSpecial(cripple)) {
								use_cripple = true;
								u = .GetBestCrippleTarget();
							}
						if (u.IsDead) {
							use_cripple = false;
							u = .FindUnitToLearn();
						}

						if (u.IsAlive)
							if (u != this) {
								learnings = 0;
								while (u.IsAlive) {
									if (.IsVisible)
										if (!u.InHolder)
											if (.CanSee(u))
												if (.InRange(u))
													if (use_cripple) {
														if (u.stamina > 0)
															if (.IsEnemy(u))
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
																	continue;
																}
													}
													else if (.experience < u.experience)
														if (!.IsEnemy(u)) {
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