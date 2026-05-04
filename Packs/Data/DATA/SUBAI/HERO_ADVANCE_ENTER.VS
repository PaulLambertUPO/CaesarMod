//void, Obj This, Obj other

if (!other.AsCatapult().IsValid)
	if (!other.AsTeleport().IsValid) {
		Hero this;

		this = This.AsHero();

		if (.IsValid)
			if (.IsAlive) {
				Building bld;

				bld = other.AsBuilding();

				if (bld.IsValid)
					if (!bld.IsHeirOf("BaseRuins"))
						if (bld.IsCentralBuliding)
							if (!.IsEnemy(bld))
								if (DiplGetShareView(bld.player, .player)) {
									Settlement set;

									set = bld.settlement;

									if (set.max_units > 0) 
										if (set.Units.Contains(this))
											.army.SetCommand("advanceenter", bld);
										else {
											ObjList h_army;
											Obj o;
											point pt;
											int i;

											pt = bld.GetEnterPoint(this);

											if (bld.DistTo(.posRH) >= 400) {
												.FormSetupAndMoveTo(pt, 0, 0, false);

												while (true) {
													if (.IsEnemyInSquadSight) {
														if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
															.AddCommand(true, "advanceenter", bld);
															.AddCommand(true, "engage");
															Sleep(30);//prevent possible loops with other commands
															return;
														}
														h_army = .army;
														for (i = h_army.count - 1; i >= 0; i -= 1) {
															o = h_army[i];
															if (o.IsAlive)
																if (o.AsUnit().BestTargetInSquadSightMisZeroDamage.IsAlive) {
																	.AddCommand(true, "advanceenter", bld);
																	.AddCommand(true, "engage");
																	Sleep(30);//prevent possible loops with other commands
																	return;
																}
														}
													}
													if (!.HasPath)
														break;
													if (.DistTo(bld) < 400)
														break;
													.FormKeepMoving(1500);
												}
											}

											if (!.IsEnemy(bld))
												if (DiplGetShareView(bld.player, .player)) {
													.army.SetCommand("advanceenter", bld);

													.SetEntering(true);

													while (true) {
														if (.IsEnemyInSquadSight) {
															if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
																.AddCommand(true, "advanceenter", bld);
																.AddCommand(true, "engage");
																break;
															}
															h_army = .army;
															for (i = h_army.count - 1; i >= 0; i -= 1) {
																o = h_army[i];
																if (o.IsAlive)
																	if (o.AsUnit().BestTargetInSquadSightMisZeroDamage.IsAlive) {
																		.AddCommand(true, "advanceenter", bld);
																		.AddCommand(true, "engage");
																		break;
																	}
															}
														}
														if (.GotoEnter(pt, 0, 1000, false, 2500)) {
															if (!.IsEnemy(bld))
																if (DiplGetShareView(bld.player, .player))
																	if (set.AddUnit(this)) {
																		h_army = .army;
																		for (i = h_army.count - 1; i >= 0; i -= 1) {
																			o = h_army[i];
																			if (o.IsAlive)
																				if (o.command == "idle")
																					o.SetCommand("advanceenter", bld);
																		}
																	}
															break;
														}
														if (.IsEnemy(bld))
															break;
													}
												}
										}
								}
			}
	}

Sleep(30);//prevent possible loops with other commands