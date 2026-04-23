//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		ObjList ol;
		Hero h;
		Unit u, u_ol;
		point pt, pt_start;
		int i, d, plr, rng, best_dist, stamina_cost;
		bool can_learn, go_back, use_curse;

		Sleep(rand(501));//avoid "thundering herd" for multiple units that start the command simultaneously

		plr = .player;
		rng = .range;
		pt_start = .posRH;

		stamina_cost = GetCmdStaminaCost("curse");

		if (.race == Carthage)
			can_learn = true;
		else
			can_learn = IsResearched(plr, "Ritual Chamber");

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
					if (.HasSpecial(curse)) {//do not use GetBestCurseTarget because it is a bugged function: it does not work for mages but only for warriors
						if (.IsVisible)
							use_curse = true;
						else if (.IsEnemyInSquadSight)
							use_curse = h.IsValid;
						else
							use_curse = false;
						if (use_curse) {
							best_dist = 10000000;
							ol = Intersect(VisibleObjsInSight(this, "Military,AttackAnimal"), EnemyObjs(plr, "Unit")).GetObjList();
							for (i = ol.count - 1; i >= 0; i -= 1) {
								u_ol = ol[i].AsUnit();
								if (u_ol.IsAlive)
									if (!u_ol.IsCursed) {
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
				if (u.IsDead)
					if (.IsVisible) {
						use_curse = false;
						if (can_learn)
							u = .FindUnitToLearn();
						else if (IsResearched(plr, "Ritual Chamber")) {
							can_learn = true;
							u = .FindUnitToLearn();
						}
					}

				if (u.IsAlive)
					if (u != this)
						if (u.DistTo(pt_start) <= rng + .sight) {
							go_back = false;
							i = 0;
							while (u.IsAlive) {
								if (!u.InHolder)
									if (.CanSee(u))
										if (use_curse) {
											if (!u.IsCursed)
												if (.IsEnemy(u))
													if (.InRange(u)) {
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

Sleep(15);//prevent possible loops with other commands