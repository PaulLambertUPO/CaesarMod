//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		ObjList ol;
		Hero h;
		Unit u, u_ol;
		point pt, pt_start;
		str cmd;
		int i, d, best_dist, plr, rng, stamina_cost;
		bool can_hide, go_back, use_invisibility;

		Sleep(rand(501));//avoid "thundering herd" for multiple units that start the command simultaneously

		pt_start = .posRH;

		plr = .player;
		rng = .range;
		stamina_cost = GetCmdStaminaCost("hide");

		can_hide = IsResearched(plr, "Mass Invisibility");

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(10000);
			else if (.Stop(2000)) {
				h = .hero;
				if (h.IsValid)
					if (h.command == "teleport") {
						Sleep(2000);
						continue;
					}

				go_back = true;

				u.Clear();
				if (can_hide) {
					if (.stamina >= stamina_cost)
						if (.HasSpecial(invisibility)) {//do not use FindUnitToHide because it is a bugged function: it always returns an invalid unit
							use_invisibility = true;
							if (.IsVisible)
								u = this;
							else if (!.IsEnemyInSquadSight) {
								best_dist = 10000000;
								ol = Intersect(VisibleObjsInSight(this, "Military"), FriendlyObjs(plr, "Military")).GetObjList();
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
				else if (IsResearched(plr, "Mass Invisibility"))//find a unit in the next iteration to avoid repeating the code above
					can_hide = true;

				if (u.IsDead)
					if (.IsVisible) {
						use_invisibility = false;
						u = .FindUnitToLearn();
					}

				if (u.IsAlive)
					if (u.DistTo(pt_start) <= rng + .sight) {
						go_back = false;
						i = 0;
						while (u.IsAlive) {
							if (!.IsEnemy(u))
								if (!u.InHolder)
									if (.CanSee(u))
										if (use_invisibility) {
											if (u.IsVisible)
												if (.InRange(u)) {
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
																						if (cmd != "stand_position")
																							if (u.TimeWithoutAttack < 1000)//other fight commands
																								u.KillCommand();
																				}
																			}

														Sleep(.TimeToAnimFinish);
														continue;
													}
												}
												else if (u.DistTo(pt_start) <= rng + .sight) {
													.GotoAttack(u, 2000, false, 2500);
													continue;
												}
										}
										else if (u != this)
											if (.experience < u.experience)
												if (.IsVisible)
													if (.InRange(u)) {
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
														if (i < 6)
															continue;
													}
													else if (u.DistTo(pt_start) <= rng + .sight) {
														.GotoAttack(u, 2000, false, 2500);
														continue;
													}
							break;
						}
					}

				if (go_back) {
					h = .hero;
					if (h.IsValid) {
						if (!h.InHolder)
							if (.DistTo(h) >= 200)
								if (.IsEnemyInSquadSight) {
									.Goto(h, 175, 2000, false, -1);
									pt_start = .pos;
									continue;
								}
					}
					else if (.AI)
						if (IsWaterLsa(GetGAIKA(this).LSA)) {//leave the coast
							pt = .pos + RandomOffset(500);
							if (pt.InRect(GetMapRect()))
								if (IsPassable3x3(pt))
									if (!IsWaterLsa(pt.GetGAIKA().LSA))
										pt_start = pt;
						}

					if (.Goto(pt_start, 0, 2000, false, 1000))
						if (rand(10) == 0) {
							pt = .GetDir();
							pt.SetLen(100);
							pt.Rot(30 - rand(61));
							.Face(pt + .pos);
						}
				}

				.Idle(1000);
			}
	}

Sleep(30);//prevent possible loops with other commands