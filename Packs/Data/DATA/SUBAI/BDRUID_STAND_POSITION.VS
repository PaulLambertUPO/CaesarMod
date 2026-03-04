//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		ObjList ol;
		Unit u, u_ol;
		str cmd;
		int i, d, best_dist, plr, rng, stamina_cost;
		bool can_learn, can_hide, use_invisibility;

		if (!.InHolder)
			while (!.Stop(1000))
				;

		Sleep(50 + rand(451));

		plr = .player;
		rng = .range;
		stamina_cost = GetCmdStaminaCost("hide");

		can_learn = IsResearched(plr, "Ritual Chamber");
		can_hide = IsResearched(plr, "Mass Concealment");

		while (.CmdCount == 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(2500);
			else {
				u.Clear();
				if (can_hide) {
					if (.stamina >= stamina_cost)
						if (.HasSpecial(invisibility)) {//do not use FindUnitToHide because it is a bugged function: it always returns an invalid unit
							use_invisibility = true;
							if (.IsVisible)
								u = this;
							else if (!.IsEnemyInSquadSight) {
								best_dist = 10000000;
								ol = Intersect(ObjsInRange(this, "Military", rng), FriendlyObjs(plr, "Military")).GetObjList();
								for (i = ol.count - 1; i >= 0; i -= 1) {
									u_ol = ol[i].AsUnit();
									if (u_ol.IsAlive)
										if (u_ol.player == plr)
											if (u_ol.IsVisible) {
												cmd = u_ol.command;
												if (cmd != "engage")
													if (cmd != "attack")
														if (cmd != "capture")
															if (!u_ol.IsSentry)
																if (!u_ol.IsRam)
																	if (!u_ol.AsShip().IsValid)
																		if (!u_ol.IsEnemyInSquadSight) {
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
							}
						}
				}
				else if (IsResearched(plr, "Mass Concealment"))//find a unit in the next iteration to avoid repeating the code above
					can_hide = true;

				if (u.IsDead)
					if (.IsVisible) {
						use_invisibility = false;
						if (can_learn)
							u = .FindUnitToLearn();
						else if (IsResearched(plr, "Ritual Chamber")) {
							can_learn = true;
							u = .FindUnitToLearn();
						}
					}

				if (u.IsAlive) {
					i = 0;
					while (u.IsAlive) {
						if (!.IsEnemy(u))
							if (!u.InHolder)
								if (.CanSee(u))
									if (.InRange(u))
										if (use_invisibility) {
											if (u.IsVisible)
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
													continue;
												}
										}
										else if (u != this)
											if (.experience < u.experience)
												if (.IsVisible) {
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

				.Idle(1000);
			}
	}

Sleep(15);//prevent possible loops with other commands