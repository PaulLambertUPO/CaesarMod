//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		Hero h;
		Unit u;
		point pt, pt_start;
		int plr, rng, teaching_level, teaching_level_max, stamina_cost, teach_percent, learnings;
		bool go_back, use_teaching;

		pt_start = .posRH;

		plr = .player;
		rng = .range;
		teaching_level = GetConst("TeachingLevel1");
		teaching_level_max = GetConst("TeachingLevel2");
		stamina_cost = GetCmdStaminaCost("teach");

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

				if (.AI)
					if (AIVar(plr, AIV_CombatMagic) != 0)
						if (IsResearched(plr, "Cover of Mercy")) {
							Sleep(100 + rand(401));
							u = .BestProtPos(150, 0, 325, 50).AsUnit();
							if (u.IsValid)
								if (!IsProtected(plr, u.posRH, "CoverOfMercy")) {
									.AddCommand(true, "coverofmercy", u.posRH);
									break;
								}
						}

				go_back = true;

				u.Clear();
				if (.stamina >= stamina_cost)
					if (.HasSpecial(teaching)) {
						if (teach_percent <= 0)
							if (IsResearched(plr, "Code of Valor"))
								teach_percent = GetConst("TeachingBonusPercent");
						if (teaching_level < teaching_level_max)
							if (IsResearched(plr, "Ancestral Knowledge"))
								teaching_level = teaching_level_max;
						if (.IsVisible) {
							use_teaching = true;
							u = .FindUnitBelowILevel(teaching_level);
						}
						else if (.IsEnemyInSquadSight) {
							if (h.IsValid) {
								use_teaching = true;
								u = .FindUnitBelowILevel(teaching_level);
							}
						}
						else {
							use_teaching = true;
							u = .FindUnitBelowILevel(teaching_level);
						}
					}
				if (u.IsDead)
					if (.IsVisible) {
						use_teaching = false;
						u = .FindUnitToLearn();
					}

				if (u.IsAlive)
					if (u != this)
						if (u.DistTo(pt_start) <= rng + .sight) {
							go_back = false;
							learnings = 0;
							while (u.IsAlive) {
								if (!.IsEnemy(u))
									if (!u.InHolder)
										if (.CanSee(u))
											if (use_teaching) {
												if (u.inherentlevel < teaching_level)
													if (.InRange(u)) {
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
													else if (u.DistTo(pt_start) <= rng + .sight) {
														.GotoAttack(u, 2000, false, 2500);
														continue;
													}
											}
											else if (.experience < u.experience)
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