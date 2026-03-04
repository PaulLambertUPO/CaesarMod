//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		Hero h;
		Unit u;
		int stamina_cost, learnings;
		bool go_to_hero, use_cripple;

		if (!.InHolder)
			while (!.Stop(1000))
				;

		Sleep(50 + rand(451));

		stamina_cost = GetCmdStaminaCost("cripple");

		while (.IsEnemyInSquadSight)
			if (.InHolder)
				Sleep(2500);
			else {
				go_to_hero = true;

				u.Clear();
				if (.stamina >= stamina_cost)
					if (.HasSpecial(cripple)) {
						use_cripple = true;
						u = .GetBestCrippleTarget();
					}
				if (u.IsDead)
					if (.IsVisible) {
						use_cripple = false;
						u = .FindUnitToLearn();
					}

				if (u.IsAlive)
					if (u != this) {
						go_to_hero = false;
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
												else {
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

Sleep(15);//prevent possible loops with other commands