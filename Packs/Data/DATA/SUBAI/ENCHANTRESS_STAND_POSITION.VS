//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Unit u;
			int teaching_level, teaching_level_max, stamina_cost, teach_percent, learnings;
			bool use_teaching;

			teaching_level = GetConst("TeachingLevel1");
			teaching_level_max = GetConst("TeachingLevel2");
			stamina_cost = GetCmdStaminaCost("teach");

			while (.CmdCount <= 1)//avoid blocking pending commands forever
				if (.Stop(2000)) {
					if (.IsVisible) {
						u.Clear();
						if (.stamina >= stamina_cost)
							if (.HasSpecial(teaching)) {
								if (teach_percent <= 0)
									if (IsResearched(.player, "Code of Valor"))
										teach_percent = GetConst("TeachingBonusPercent");
								if (teaching_level < teaching_level_max)
									if (IsResearched(.player, "Ancestral Knowledge"))
										teaching_level = teaching_level_max;
								use_teaching = true;
								u = .FindUnitBelowILevel(teaching_level);
							}
						if (u.IsDead) {
							use_teaching = false;
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
														if (use_teaching) {
															if (u.inherentlevel < teaching_level)
																if (.stamina >= stamina_cost) {
																	.StartAnim(17, u.pos);

																	Sleep(.TimeToActionMoment);

																	if (u.IsAlive)
																		if (u.inherentlevel < teaching_level)
																			if (!.IsEnemy(u))
																				if (!u.InHolder)
																					if (.CanSee(u))
																						if (.stamina >= stamina_cost) {
																							.SetLastAttackTime();
																							if (!.IsVisible)
																								.SetVisible(true);
																							.SetStamina(.stamina - stamina_cost);
																							u.SetExperience(u.experience + MIN(6, 1 + .level * teach_percent / 100));
																							CreateFeedback("Experience", u);
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

Sleep(15);//prevent possible loops with other commands