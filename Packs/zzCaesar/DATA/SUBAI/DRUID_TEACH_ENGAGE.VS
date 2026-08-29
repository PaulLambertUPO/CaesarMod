//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Hero h;
			Unit u;
			int plr, teaching_level, teaching_level_max, stamina_cost, teach_percent, learnings;
			bool go_to_hero, use_teaching;

			Sleep(rand(501));//avoid "thundering herd" for multiple units that start the command simultaneously

			plr = .player;
			teaching_level = GetConst("TeachingLevel1");
			teaching_level_max = GetConst("TeachingLevel2");
			stamina_cost = GetCmdStaminaCost("teach");

			while (.IsEnemyInSquadSight) {
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

				go_to_hero = true;

				u.Clear();
				if (.stamina >= stamina_cost)
					if (.HasSpecial(teaching)) {
						if (teach_percent <= 0)
							if (IsResearched(plr, "Code of Valor"))
								teach_percent = GetConst("TeachingBonusPercent");
						if (teaching_level < teaching_level_max)
							if (IsResearched(plr, "Ancestral Knowledge"))
								teaching_level = teaching_level_max;
						use_teaching = true;
						u = .FindUnitBelowILevel(teaching_level);
					}
				if (u.IsDead)
					if (.IsVisible) {
						use_teaching = false;
						u = .FindUnitToLearn();
					}

				if (u.IsAlive)
					if (u != this) {
						go_to_hero = false;
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
												else {
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
													if (learnings < 3)
														continue;
												}
												else {
													.GotoAttack(u, 2000, false, 2500);
													continue;
												}
							break;
						}
					}

				if (go_to_hero) {
					h = .hero;
					if (h.IsValid)
						if (!h.InHolder)
							if (.DistTo(h) >= 200)
								.Goto(h, 175, 2000, false, -1);
				}

				Sleep(500);
			}
		}

Sleep(30);//prevent possible loops with other commands