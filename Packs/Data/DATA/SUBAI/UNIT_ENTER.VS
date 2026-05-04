//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building bld;

		if (.AI)
			.SetParryMode(false);

		bld = other.AsBuilding();

		if (bld.IsValid)
			if (bld.AsTeleport().IsValid) {
				Settlement set;

				set = bld.settlement;

				if (!set.Units.Contains(this)) {
					point pt;

					pt = bld.GetEnterPoint(this);

					.SetEntering(true);

					while (!.GotoEnter(pt, 0, 1000, false, 2500))
						;

					set.AddUnit(this);
				}
			}
			else if (!bld.IsHeirOf("BaseRuins"))
				if (bld.IsCentralBuliding)
					if (!.IsEnemy(bld))
						if (DiplGetShareView(bld.player, .player)) {
							Settlement set;

							set = bld.settlement;

							if (set.max_units > 0)
								if (set.Units.Contains(this)) {
									if (bld.AsCatapult().IsValid)
										if (.hero.IsValid)
											.DetachFrom(.hero);
								}
								else {
									point pt;

									pt = bld.GetEnterPoint(this);

									.SetEntering(true);

									if (bld.AsCatapult().IsValid) {
										while (!.GotoEnter(pt, 0, 1000, false, 2500)) {
											if (bld.IsDead)
												break;
											if (.IsEnemy(bld))
												break;
										}

										if (bld.IsAlive)
											if (!.IsEnemy(bld))
												if (DiplGetShareView(bld.player, .player)) {
													bool add = true;

													if (bld.AsCatapult().IsBuilt)//avoid entering rams that have already been built
														if (bld.race == Britain)
															add = false;
														else if (bld.race == Germany)
															add = false;

													if (add)
														if (set.AddUnit(this)) {
															.Deselect();
															if (.hero.IsValid)
																.DetachFrom(.hero);
														}
												}
									}
									else {
										while (!.GotoEnter(pt, 0, 1000, false, 2500))
											if (.IsEnemy(bld))
												break;

										if (!.IsEnemy(bld))
											if (DiplGetShareView(bld.player, .player))
												set.AddUnit(this);
									}
								}
						}
	}

Sleep(30);//prevent possible loops with other commands