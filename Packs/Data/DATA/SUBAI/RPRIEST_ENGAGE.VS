//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Hero h;
			Unit u;
			int heal_amount, stamina_cost, learnings;
			bool can_learn, go_to_hero, use_healing;

			Sleep(rand(501));//avoid "thundering herd" for multiple units that start the command simultaneously

			heal_amount = GetConst("HealAmount");
			stamina_cost = GetCmdStaminaCost("heal");

			if (.race != Gaul)
				can_learn = true;
			else
				can_learn = IsResearched(.player, "Ritual Chamber");

			while (.IsEnemyInSquadSight) {
				go_to_hero = true;

				u.Clear();
				if (.stamina >= stamina_cost)
					if (.HasSpecial(healing)) {
						use_healing = true;
						u = .FindUnitToHeal();
					}
				if (u.IsDead)
					if (.IsVisible) {
						use_healing = false;
						if (can_learn)
							u = .FindUnitToLearn();
						else if (IsResearched(.player, "Ritual Chamber")) {
							can_learn = true;
							u = .FindUnitToLearn();
						}
					}

				if (u.IsAlive)
					if (u != this) {
						go_to_hero = false;
						learnings = 0;
						while (u.IsAlive) {
							if (!.IsEnemy(u))
								if (!u.InHolder)
									if (.CanSee(u))
										if (use_healing) {
											if (u.health < u.maxhealth)
												if (.InRange(u)) {
													if (.stamina >= stamina_cost) {
														.StartAnim(17, u.pos);

														Sleep(.TimeToActionMoment);

														if (u.IsAlive)
															if (u.health < u.maxhealth)
																if (!.IsEnemy(u))
																	if (!u.InHolder)
																		if (.CanSee(u))
																			if (.stamina >= stamina_cost) {
																				.SetLastAttackTime();
																				if (!.IsVisible)
																					.SetVisible(true);
																				.SetStamina(.stamina - stamina_cost);
																				u.Heal(heal_amount + .level);
																				CreateFeedback("Heal", u);
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

Sleep(15);//prevent possible loops with other commands