//void, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		Unit u;

		{
			int r;
			r = .race;
			if (r == Gaul) {
				if (IsResearched(.player, "Ritual Chamber"))
					u = target.AsUnit();
			}
			else if (r == Britain) {
				if (IsResearched(.player, "Ritual Chamber"))
					u = target.AsUnit();
			}
			else if (r == Germany) {
				if (IsResearched(.player, "Ritual Chamber"))
					u = target.AsUnit();
			}
			else
				u = target.AsUnit();
		}

		if (u.IsValid)
			if (!u.IsWaterUnit)
				if (!u.IsRam) {
					while (u.IsAlive) {
						if (.experience < u.experience)
							if (!.IsEnemy(u))
								if (!u.InHolder)
									if (.CanSee(u)) {
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
										}
										else
											.GotoAttack(u, 2000, false, 2500);

										continue;
									}
						break;
					}
				}
	}

Sleep(15);//prevent possible loops with other commands