//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			ObjList ol;
			Hero h;
			Unit u, u_ol;
			int i, d, plr, best_dist, stamina_cost;
			bool can_learn, go_to_hero, use_curse;

			plr = .player;
			stamina_cost = GetCmdStaminaCost("curse");

			if (.race == Carthage)
				can_learn = true;
			else
				can_learn = IsResearched(plr, "Ritual Chamber");

			while (.IsEnemyInSquadSight) {
				go_to_hero = true;

				u.Clear();
				if (.stamina >= stamina_cost)
					if (.HasSpecial(curse)) {//do not use GetBestCurseTarget because it is a bugged function: it does not work for mages but only for warriors
						use_curse = true;
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
					if (u != this) {
						go_to_hero = false;
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
													i += 1;
													if (i < 3)
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