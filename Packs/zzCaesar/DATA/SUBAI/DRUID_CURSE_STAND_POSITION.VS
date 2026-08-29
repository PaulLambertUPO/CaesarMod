//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			ObjList ol;
			Unit u, u_ol;
			int i, d, plr, rng, best_dist, stamina_cost;
			bool use_curse;

			Sleep(rand(501));//avoid "thundering herd" for multiple units that start the command simultaneously

			plr = .player;
			rng = .range;
			stamina_cost = GetCmdStaminaCost("curse");

			while (.CmdCount <= 1)//avoid blocking pending commands forever
				if (.Stop(2000)) {
					if (.IsVisible) {
						u.Clear();
						if (.stamina >= stamina_cost)
							if (.HasSpecial(curse)) {//do not use GetBestCurseTarget because it is a bugged function: it does not work for mages but only for warriors
								use_curse = true;
								best_dist = 10000000;
								ol = Intersect(Union(ObjsInRange(this, "Military", rng), ObjsInRange(this, "AttackAnimal", rng)), EnemyObjs(plr, "Unit")).GetObjList();
								for (i = ol.count - 1; i >= 0; i -= 1) {
									u_ol = ol[i].AsUnit();
									if (u_ol.IsAlive)
										if (!u_ol.AsShip().IsValid)
											if (!u_ol.IsCursed)
												if (u_ol.IsVisible) {
													d = .DistTo(u_ol);
													if (u.IsDead) {
														u = u_ol;
														best_dist = d;
													}
													else if (d < best_dist) {
														u = u_ol;
														best_dist = d;
													}
												}
								}
							}
						if (u.IsDead) {
							use_curse = false;
							u = .FindUnitToLearn();
						}

						if (u.IsAlive)
							if (u != this) {
								i = 0;
								while (u.IsAlive) {
									if (.IsVisible)
										if (!u.InHolder)
											if (.CanSee(u))
												if (.InRange(u))
													if (use_curse) {
														if (!u.IsCursed)
															if (.IsEnemy(u))
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
															i += 1;
															if (i < 12)
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