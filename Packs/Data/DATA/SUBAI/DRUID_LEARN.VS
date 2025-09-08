//void, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid) {
	if (.race == Gaul) {
		if (!IsResearched(.player, "Ritual Chamber"))
			return;
	}
	else if (.race == Britain) {
		if (!IsResearched(.player, "Ritual Chamber"))
			return;
	}
	else if (.race == Germany)
		if (!IsResearched(.player, "Ritual Chamber"))
			return;

	if (.IsAlive) {
		Unit u;

		u = target.AsUnit();

		if (u.IsValid)
			if (!u.AsShip().IsValid) {
				while (u.IsAlive) {
					if (.experience < u.experience)
						if (!.IsEnemy(u))
							if (!u.InHolder)
								if (!.InShip)
									if (.CanSee(u)) {
										if (.InRange(u)) {
											.StartAnim(19, u.pos);

											Sleep(.TimeToActionMoment);

											if (.experience < u.experience)
												if (!.IsEnemy(u))
													if (!u.InHolder)
														if (!.InShip)
															if (.CanSee(u)) {
																if (!.IsVisible)
																	.SetVisible(true);
																.SetLastAttackTime();
																.SetExperience(MIN(u.experience, .experience + (.inherentlevel + 4) / 4));
																CreateFeedback("Experience", this);
															}

											Sleep(.TimeToAnimFinish);
										}
										else
											.GotoAttack(u, 5000, false, 2500);

										continue;
									}
					Sleep(500);
					break;
				}
			}
	}
}