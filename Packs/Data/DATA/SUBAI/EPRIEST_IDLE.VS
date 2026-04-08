//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		Hero h;
		Unit u;
		point pt, pt_start;
		int rng, stamina_cost, learnings;
		bool go_back, use_cripple;

		pt_start = .posRH;

		rng = .range;
		stamina_cost = GetCmdStaminaCost("cripple");

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(2500);
			else if (.Stop(2000)) {
				h = .hero;
				if (h.IsValid)
					if (h.command == "teleport") {
						Sleep(2000);
						continue;
					}

				go_back = true;

				u.Clear();
				if (.stamina >= stamina_cost)
					if (.HasSpecial(cripple))
						if (.IsVisible) {
							use_cripple = true;
							u = .GetBestCrippleTarget();
						}
						else if (.IsEnemyInSquadSight)
							if (h.IsValid) {
								use_cripple = true;
								u = .GetBestCrippleTarget();
							}
				if (u.IsDead) {
					use_cripple = false;
					u = .FindUnitToLearn();
				}

				if (u.IsAlive)
					if (u != this)
						if (u.DistTo(pt_start) <= rng + .sight) {
							go_back = false;
							learnings = 0;
							while (u.IsAlive) {
								if (!u.InHolder)
									if (.CanSee(u))
										if (use_cripple) {
											if (u.stamina > 0)
												if (.IsEnemy(u))
													if (.InRange(u)) {
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
													else if (u.DistTo(pt_start) <= rng + .sight) {
														.GotoAttack(u, 2000, false, 2500);
														continue;
													}
										}
										else if (.experience < u.experience)
											if (.IsVisible)
												if (!.IsEnemy(u))
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
														learnings += 1;
														if (learnings < 6)
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
							pt = .pos;
							pt.Set(pt.x + 250 - rand(501), pt.y + 250 - rand(501));
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

Sleep(15);//prevent possible loops with other commands