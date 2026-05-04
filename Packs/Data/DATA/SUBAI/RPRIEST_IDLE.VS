//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		Hero h;
		Unit u;
		point pt, pt_start;
		int rng, heal_amount, stamina_cost, learnings;
		bool can_learn, go_back, use_healing;

		Sleep(rand(501));//avoid "thundering herd" for multiple units that start the command simultaneously

		pt_start = .posRH;

		rng = .range;
		heal_amount = GetConst("HealAmount");
		stamina_cost = GetCmdStaminaCost("heal");

		if (.race != Gaul)
			can_learn = true;
		else
			can_learn = IsResearched(.player, "Ritual Chamber");

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
				if (.stamina >= stamina_cost)
					if (.HasSpecial(healing))
						if (.IsVisible) {
							use_healing = true;
							u = .FindUnitToHeal();
						}
						else if (.IsEnemyInSquadSight) {
							if (h.IsValid) {
								use_healing = true;
								u = .FindUnitToHeal();
							}
						}
						else {
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
					if (u != this)
						if (u.DistTo(pt_start) <= rng + .sight) {
							go_back = false;
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