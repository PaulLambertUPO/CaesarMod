//void, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(teaching))
			if (target != this) {
				Unit u;

				u = target.AsUnit();

				if (u.IsValid)
					if (!u.IsPeasantAmbient)
						if (!u.IsWaterUnit)
							if (!u.IsRam) {
								int teaching_level, teaching_level_max, stamina_cost, teach_percent;

								teaching_level = GetConst("TeachingLevel1");
								teaching_level_max = GetConst("TeachingLevel2");
								stamina_cost = GetCmdStaminaCost("teach");

								while (u.IsAlive) {
									if (teach_percent <= 0)
										if (IsResearched(.player, "Code of Valor"))
											teach_percent = GetConst("TeachingBonusPercent");
									if (teaching_level < teaching_level_max)
										if (IsResearched(.player, "Ancestral Knowledge"))
											teaching_level = teaching_level_max;

									if (u.inherentlevel < teaching_level)
										if (!.IsEnemy(u))
											if (!u.InHolder)
												if (.CanSee(u)) {
													if (.InRange(u))
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