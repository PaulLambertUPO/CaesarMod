//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Hero h;
			Unit u;
			int stamina_cost, learnings;
			bool can_learn, go_to_hero;

			stamina_cost = GetCmdStaminaCost("hide");

			can_learn = IsResearched(.player, "Ritual Chamber");

			while (.IsEnemyInSquadSight) {
				go_to_hero = true;

				if (.IsVisible) {
					u.Clear();
					if (can_learn)
						u = .FindUnitToLearn();
					else if (IsResearched(.player, "Ritual Chamber")) {
						can_learn = true;
						u = .FindUnitToLearn();
					}

					if (u.IsAlive)
						if (u != this) {
							go_to_hero = false;
							learnings = 0;
							while (u.IsAlive) {
								if (.experience < u.experience)
									if (!.IsEnemy(u))
										if (!u.InHolder)
											if (.CanSee(u))
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