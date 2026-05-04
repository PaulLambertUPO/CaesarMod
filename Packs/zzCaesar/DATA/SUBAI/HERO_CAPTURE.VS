//void, Obj This, Obj target

if (target.IsValid) {
	Hero this;

	this = This.AsHero();

	if (.IsValid)
		if (.IsAlive) {
			int plr;

			plr = .player;

			if (target.player != plr)
				if (target.AsBuilding().IsValid) {
					if (.IsValidCaptureTarget(target)) {
						Settlement set;
						point pt_pos;

						set = target.AsBuilding().settlement;

						if (!target.AsBuilding().IsCentralBuliding)
							target = set.GetCentralBuilding();

						pt_pos = target.pos;

						if (target.DistTo(.posRH) > 350) {
							.FormSetupAndMoveTo(pt_pos, 0, 0, true);
							while (.HasPath) {
								if (.DistTo(target) <= 350)
									break;
								.FormKeepMoving(1500);
							}
						}

						if (target.player != plr)
							if (.IsValidCaptureTarget(target)) {
								if (set.IsTTent) {
									if (target.IsEnemy(this)) {
										if (.HasSpecial(sneak))
											.SetLastAttackTime();
										if (!.IsVisible)
											.SetVisible(true);
										.AddCommand(true, "engage");
										Sleep(30);//prevent possible loops with other commands
										return;
									}
								}
								else if (set.IsOutpost)
									if (set.IsIndependent) {
										if (.HasSpecial(sneak))
											.SetLastAttackTime();
										if (!.IsVisible)
											.SetVisible(true);
										.AddCommand(true, "engage");
										Sleep(30);//prevent possible loops with other commands
										return;
									}

								.army.SetCommand("capture", target);

								{
									ObjList h_army;
									Obj o;
									int i;

									while (target.player != plr) {
										if (!.IsValidCaptureTarget(target))
											break;
										if (.Goto(target, 250, 2500, true, 2500)) {
											if (target.player == plr)
												break;
											if (!.IsValidCaptureTarget(target))
												break;
											if (!target.IsEnemy(this)) {//non-hostile players immediately give the target
												set.SetPlayer(plr);
												break;
											}
											while (target.IsEnemy(this)) {
												if (set.loyalty <= 0) {
													set.SetPlayer(plr);
													set.SetLoyalty(11);
													break;
												}
												UserNotification("building attacked", "", pt_pos, target.player);

												.SetLastAttackTime();
												if (!.IsVisible)
													.SetVisible(true);

												.Face(pt_pos);
												h_army = .army;
												for (i = h_army.count - 1; i >= 0; i -= 1) {//new units might be attached during the capture
													o = h_army[i];
													if (o.IsAlive)
														if (o.command == "idle")
															if (o.IsValidCaptureTarget(target))
																o.SetCommand("capture", target);
												}
												.Taunt(2000);

												if (target.player == plr)
													break;
												if (!.IsValidCaptureTarget(target))
													break;
												if (target.IsEnemy(this))
													set.DecreaseLoyalty(1);
												else {
													set.SetPlayer(plr);
													break;
												}
											}
										}
									}
								}
							}
					}
				}
				else if (target.AsWagon().IsValid) {
					Wagon w;

					w = target.AsWagon();

					if (w.IsAlive)
						if (!w.InHolder) {
							if (.DistTo(w) >= 300) {
								.FormSetupAndMoveTo(w.pos, 0, 0, true);
								while (.HasPath) {
									.FormKeepMoving(1500);
									if (w.IsDead)
										break;
									if (w.InHolder)
										break;
									if (.DistTo(w) < 300)
										break;
									.FormSetupAndMoveTo(w.pos, 0, 0, true);
								}
							}

							if (w.IsAlive)
								if (w.player != plr)
									if (!w.InHolder) {
										ObjList h_army;
										Obj o;
										int i;

										.army.SetCommand("capture", w);

										while (w.IsAlive) {
											if (w.player == plr)
												break;
											if (w.InHolder)
												break;
											if (.Goto(w, 150, 2500, true, 2500)) {
												if (w.IsDead)
													break;
												if (w.player == plr)
													break;
												if (w.InHolder)
													break;
												if (!w.IsEnemy(this)) {//non-hostile players immediately give the target
													w.SetPlayer(plr);
													break;
												}
												if (w.loyalty <= 0) {
													w.SetPlayer(plr);
													break;
												}
												UserNotification("unit attacked", "", w.pos, w.player);

												.SetLastAttackTime();
												if (!.IsVisible)
													.SetVisible(true);

												.Face(w.pos);
												h_army = .army;
												for (i = h_army.count - 1; i >= 0; i -= 1) {//new units might be attached during the capture
													o = h_army[i];
													if (o.IsAlive)
														if (o.command == "idle")
															o.SetCommand("capture", w);
												}
												.Taunt(2000);

												if (w.IsAlive)
													if (w.player != plr)
														if (!w.InHolder)
															if (w.IsEnemy(this))
																w.DecreaseLoyalty(1);
															else {
																w.SetPlayer(plr);
																break;
															}
											}
										}
									}
						}
				}
				else if (target.IsHeirOf("WildHorse"))
					if (IsResearched(plr, "Tame horses")) {
						Unit u;

						u = target.AsUnit();

						if (u.IsAlive)
							if (!u.InHolder) {
								if (.DistTo(u) >= 300) {
									.FormSetupAndMoveTo(u.pos, 0, 0, true);
									while (.HasPath) {
										.FormKeepMoving(1500);
										if (u.IsDead)
											break;
										if (u.InHolder)
											break;
										if (.DistTo(u) < 300)
											break;
										.FormSetupAndMoveTo(u.pos, 0, 0, true);
									}
								}

								if (u.IsAlive)
									if (u.player != plr)
										if (!u.InHolder) {
											ObjList h_army;
											Obj o;
											int i;

											.army.SetCommand("capture", u);

											while (u.IsAlive) {
												if (u.player == plr)
													break;
												if (u.InHolder)
													break;
												if (.Goto(u, 150, 2500, true, 2500)) {
													if (u.IsDead)
														break;
													if (u.player == plr)
														break;
													if (u.InHolder)
														break;
													if (!u.IsEnemy(this)) {//non-hostile players immediately give the target
														u.SetPlayer(plr);
														break;
													}
													UserNotification("unit attacked", "", u.pos, u.player);

													.SetLastAttackTime();
													if (!.IsVisible)
														.SetVisible(true);

													.Face(u.pos);
													h_army = .army;
													for (i = h_army.count - 1; i >= 0; i -= 1) {//new units might be attached during the capture
														o = h_army[i];
														if (o.IsAlive)
															if (o.command == "idle")
																o.SetCommand("capture", u);
													}
													.Taunt(2000);

													if (u.IsAlive)
														if (u.player != plr)
															if (!u.InHolder) {
																u.SetPlayer(plr);
																u.SetCommand("move", .pos);
																UserNotification("horse captured", "", u.pos, plr);
															}
												}
											}
										}
							}
					}
		}
}

Sleep(30);//prevent possible loops with other commands