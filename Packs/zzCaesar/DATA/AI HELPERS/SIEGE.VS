//void, str GroupName, str Target

//note for stronghold: this script does not manage multiple gates or repairs

Settlement set;

set = GetSettlement(Target);

if (set.IsValid) {
	Building main_target;

	main_target = set.GetCentralBuilding();

	if (main_target.IsValid) {
		Query q_siegers;
		ObjList ol_siegers;

		q_siegers = Group(GroupName);
		ol_siegers = q_siegers.GetObjList();

		if (ol_siegers.count > 0)
			if (ol_siegers[0].IsEnemy(main_target)) {
				Unit u, u_tmp;
				str u_cmd;
				rect rc;
				point pt, main_target_pos;
				int i, j;

				rc = GetMapRect();
				main_target_pos = main_target.pos;

				if (set.IsOutpost) {
					bool cataps_or_ranged, is_sieging = false;

					//step 1: wait for most heroes and unattached units to gather near the outpost
					while (1) {
						j = 0;
						ol_siegers = q_siegers.GetObjList();
						if (ol_siegers.count <= 0)
							return;
						if (!ol_siegers[0].IsEnemy(main_target))
							return;
						for (i = 0; i < ol_siegers.count; i += 1) {
							u = ol_siegers[i].AsUnit();
							if (u.IsValid)
								if (!u.hero.IsValid) {
									u_cmd = u.command;
									if (u.DistTo(main_target) > 1600) {
										if (u_cmd == "move") {
											u_tmp = u.BestTargetInSquadSight("Military");//ignore sentries but not the other warriors
											if (u_tmp.IsValid)
												if (!u_tmp.IsSentry)
													u.SetCommand("advance", main_target_pos);
										}
										else if (u_cmd == "engage") {
											u_tmp = u.BestTargetInSquadSight("Military");//avoid fighting sentries forever
											if (!u_tmp.IsValid)
												u.SetCommand("move", main_target_pos);
											else if (u_tmp.IsSentry)
												u.SetCommand("move", main_target_pos);
										}
										else if (u_cmd != "advance")
											u.SetCommand("advance", main_target_pos);
									}
									else {
										if (u_cmd != "capture")
											if (u_cmd != "engage")
												if (u_cmd != "idle") {
													u_tmp = u.BestTargetInSquadSight("Military");
													if (!u_tmp.IsValid) {
														if (set.UnitsCount <= 0)
															u.SetCommand("capture", main_target);
														else
															u.SetCommand("idle");
													}
													else if (!u_tmp.IsSentry)
														u.SetCommand("advance", u_tmp.pos);
													else if (set.UnitsCount <= 0)
														u.SetCommand("capture", main_target);
													else
														u.SetCommand("idle");
												}
										j += 1;
										if (u.AsHero().IsValid)
											j += u.AsHero().army.count;
									}
								}
						}
						if (j >= ol_siegers.count * 2 / 3)
							break;
						Sleep(2000);
					}

					//step 2: siege (only if there are units inside and the attackers are not heavily outnumbering the defenders) and capture
					while (1) {
						ol_siegers = q_siegers.GetObjList();
						if (ol_siegers.count <= 0)
							return;
						if (!ol_siegers[0].IsEnemy(main_target))
							break;//use break instead of return in order to clear catapults (step 3)

						i = set.UnitsCount;
						if (i > 0) {
							if (ol_siegers.count > 4 * (i + Intersect(VisibleObjsInSight(main_target, "Military"), FriendlyObjs(main_target.player, "Military")).count))
								is_sieging = false;
							else if (!is_sieging) {
								ol_siegers.Siege(main_target, MAX(1, ol_siegers.count / 20), 0);//max catapults
								is_sieging = true;
							}
						}
						else
							is_sieging = false;

						cataps_or_ranged = false;
						for (i = 0; i < ol_siegers.count; i += 1) {
							u = ol_siegers[i].AsUnit();
							if (u.IsValid)
								if (!u.hero.IsValid) {
									if (u.InHolder)
										if (is_sieging)
											cataps_or_ranged = true;
										else {
											u.SetCommand("advance", main_target_pos);
											u.AddCommand(false, "capture", main_target);
										}
									else {
										u_cmd = u.command;
										if (u_cmd == "build_catapult")
											if (is_sieging)
												cataps_or_ranged = true;
											else {
												u.SetCommand("advance", main_target_pos);
												u.AddCommand(false, "capture", main_target);
											}
										else if (is_sieging)
											if (u.DistTo(main_target) > 1600) {//try to reach the outpost as soon as possible when far (new units added to the group)
												if (u_cmd == "idle")
													u.SetCommand("advance", main_target_pos);
												else if (u_cmd == "engage") {
													u_tmp = u.BestTargetInSquadSight("Military");//ignore sentries found on the way
													if (!u_tmp.IsValid)
														u.SetCommand("move", main_target_pos);
													else if (u_tmp.IsSentry)
														u.SetCommand("move", main_target_pos);
													else if (rand(15) == 0)//low chance to reduce the risk of a move-engage cycle and attract more enemies to the outpost
														u.SetCommand("move", main_target_pos);
												}
												else if (u_cmd == "move")
													if (rand(3) == 0) {
														u_tmp = u.BestTargetInSquadSight("Military");
														if (u_tmp.IsValid)
															if (!u_tmp.IsSentry)
																u.SetCommand("advance", main_target_pos);
													}
											}
											else {
												if (u_cmd != "capture")
													if (u_cmd != "attack")
														if (u_cmd != "idle")
															if (u_cmd != "move")
																continue;
												if (u.AsHero().IsValid) {
													u_tmp = u.BestTargetInSquadSight("Military");
													if (!u_tmp.IsValid) {//if there is not an enemy warrior nearby, hero armies will attack/capture the target if many units are ranged
														ObjList army;
														int r;

														army = u.AsHero().army;
														for (j = 0; j < army.count; j += 1)
															if (army[j].IsRanged)
																r += 1;

														if (r >= 30) {
															if (u.IsRanged) {
																if (u_cmd != "attack")
																	u.SetCommand("attack", main_target);
															}
															else if (u_cmd != "capture")
																u.SetCommand("capture", main_target);

															//keep army commands after the hero otherwise the latter overwrites them
															for (j = 0; j < army.count; j += 1) {
																u_tmp = army[j].AsUnit();
																if (u_tmp.IsRanged) {
																	if (u_tmp.command != "attack")
																		u_tmp.SetCommand("attack", main_target);
																}
																else if (u_tmp.command != "capture")
																	u_tmp.SetCommand("capture", main_target);
															}
															cataps_or_ranged = true;
															continue;
														}
													}
												}
												else if (u.IsRanged) {//order unattached ranged unit to attack the target if there is not an enemy warrior nearby
													u_tmp = u.BestTargetInSquadSight("Military");
													if (!u_tmp.IsValid) {
														if (u_cmd != "attack")
															u.SetCommand("attack", main_target);
														cataps_or_ranged = true;
														continue;
													}
												}
												//advance to a point that is not too close to the garrisoned outpost
												pt = u.pos - main_target_pos;
												j = pt.Len + 1;
												if (j < 900) {
													pt = pt * (900 + rand(100)) / j;
													pt = pt + main_target_pos;
													pt.IntoRect(rc);
													u.SetCommand("advance", pt);
												}
												else if (j > 1000) {
													pt = pt * (900 + rand(100)) / j;
													pt = pt + main_target_pos;
													pt.IntoRect(rc);
													u.SetCommand("advance", pt);
												}
											}
										else if (u_cmd == "attack") {//ranged units that are still firing when siege has ended
											u.SetCommand("engage");
											u.AddCommand(false, "capture", main_target);
										}
										else if (u_cmd == "idle") {//new units added to the group and heroes who are interrupted while capturing (normal units become "engage" instead)
											u.SetCommand("engage");
											u.AddCommand(false, "capture", main_target);
										}
										else if (u_cmd == "capture") {//chance to abort the capture and attack an enemy warrior nearby (ignore sentries)
											if (u.AsHero().IsValid) {//attached ranged units might keep firing if the hero is already capturing the target when siege has ended
												ObjList army;
												army = u.AsHero().army;
												for (j = 0; j < army.count; j += 1)
													if (army[j].command == "attack")
														army[j].SetCommand("capture", main_target);
											}
											if (u.DistTo(main_target) <= 550) {
												if (rand(8) == 0) {//small chance in order to reduce the risk of interrupting the capture when the defender keeps sending units
													u_tmp = u.BestTargetInSquadSight("Military");
													if (u_tmp.IsValid)
														if (!u_tmp.IsSentry)
															u.SetCommand("advance", u_tmp.pos);
												}
											}
											else if (rand(2) == 0) {//good chance in order to reduce the risk of ignoring the enemy (for idle units and new ones added to the group)
												u_tmp = u.BestTargetInSquadSight("Military");
												if (u_tmp.IsValid)
													if (!u_tmp.IsSentry)
														u.SetCommand("advance", main_target_pos);
											}
										}
										else if (u_cmd == "engage") {//chance to interrupt the fight and either capture the target or move to it depending on the distance
											u_tmp = u.BestTargetInSquadSight("Military");
											if (!u_tmp.IsValid)
												if (u.DistTo(main_target) <= 400)
													u.SetCommand("capture", main_target);
												else
													u.SetCommand("move", main_target_pos);
											else if (u_tmp.IsSentry)
												if (u.DistTo(main_target) <= 400)
													u.SetCommand("capture", main_target);
												else
													u.SetCommand("move", main_target_pos);
											else if (u.DistTo(main_target) <= 350) {//shorter distance to reduce the risk of stopping fighting real enemies (not barracks-trained units)
												if (rand(5) == 0)
													u.SetCommand("capture", main_target);
											}
											else if (rand(15) == 0)//low chance to reduce the risk of a move-engage cycle
												u.SetCommand("move", main_target_pos);
										}
										else if (u_cmd == "move") {//when near, stop moving and start capture
											if (u.DistTo(main_target) <= 300) {
												u.SetCommand("engage");
												u.AddCommand(false, "capture", main_target);
											}
											else if (rand(3) == 0) {
												u_tmp = u.BestTargetInSquadSight("Military");
												if (u_tmp.IsValid)
													if (!u_tmp.IsSentry)
														u.SetCommand("advance", main_target_pos);
											}
										}
									}
								}
						}
						is_sieging = cataps_or_ranged;
						Sleep(2000);
					}

					//step 3: clear catapults
					for (i = 0; i < ol_siegers.count; i += 1) {
						u = ol_siegers[i].AsUnit();
						if (u.IsValid)
							if (!u.hero.IsValid)
								if (u.GetHolderSett().IsValid) {
									Catapult c;
									c = u.GetHolderSett().GetCentralBuilding().AsCatapult();
									if (c.IsValid)
										c.SetCommand("disband");
								}
					}
				}
				else {
					if (set.IsStronghold) {
						Gate gate;

						gate = set.BestGate(ol_siegers[0].pos);

						if (gate.IsValid) {
							point gate_pos;
							bool cataps_placed, is_sieging = false;

							gate_pos = gate.pos;

							//step 1: wait for most heroes and unattached units to gather near the gate
							while (1) {
								j = 0;
								ol_siegers = q_siegers.GetObjList();
								if (ol_siegers.count <= 0)
									return;
								if (!ol_siegers[0].IsEnemy(gate))
									return;
								for (i = 0; i < ol_siegers.count; i += 1) {
									u = ol_siegers[i].AsUnit();
									if (u.IsValid)
										if (!u.hero.IsValid) {
											u_cmd = u.command;
											if (u.DistTo(gate) > 1200) {
												if (u_cmd == "move") {
													u_tmp = u.BestTargetInSquadSight("Military");//ignore sentries but not the other warriors
													if (u_tmp.IsValid)
														if (!u_tmp.IsSentry)
															u.SetCommand("advance", gate_pos);
												}
												else if (u_cmd == "engage") {
													u_tmp = u.BestTargetInSquadSight("Military");//avoid fighting sentries forever
													if (!u_tmp.IsValid)
														u.SetCommand("move", gate_pos);
													else if (u_tmp.IsSentry)
														u.SetCommand("move", gate_pos);
												}
												else if (u_cmd != "advance")
													u.SetCommand("advance", gate_pos);
											}
											else {
												if (u_cmd != "idle")
													if (u_cmd != "engage")
														u.SetCommand("idle");
												j += 1;
												if (u.AsHero().IsValid)
													j += u.AsHero().army.count;
											}
										}
								}
								if (j >= ol_siegers.count * 2 / 3)
									break;
								Sleep(2000);
							}

							//step 2: siege to break gate
							while (!gate.IsBroken) {
								ol_siegers = q_siegers.GetObjList();
								if (ol_siegers.count <= 0)
									return;
								if (!ol_siegers[0].IsEnemy(gate))
									break;//use break instead of return in order to clear catapults (step 3)

								if (!is_sieging) {
									ol_siegers.Siege(gate, MAX(1, ol_siegers.count / 20), 0);//max catapults
									is_sieging = true;
								}

								cataps_placed = false;
								for (i = 0; i < ol_siegers.count; i += 1) {
									u = ol_siegers[i].AsUnit();
									if (u.IsValid)
										if (!u.hero.IsValid) {
											if (u.InHolder)
												cataps_placed = true;
											else {
												u_cmd = u.command;
												if (u_cmd == "build_catapult")
													cataps_placed = true;
												else if (u_cmd == "idle") {
													//for some reason, units sometimes do not attack the gate by calling the Siege function (it seems to happen with multiple heroes)
													if (u.AsHero().IsValid)
														u.SetCommand("attack", gate);
													else if (u.IsRanged)
														u.SetCommand("attack", gate);
													else {
														//advance to a point that is not too close to the gate
														pt = u.pos - gate_pos;
														j = pt.Len + 1;
														if (j < 900) {
															pt = pt * (900 + rand(100)) / j;
															pt = pt + gate_pos;
															pt.IntoRect(rc);
															u.SetCommand("advance", pt);
														}
														else if (j > 1000) {
															pt = pt * (900 + rand(100)) / j;
															pt = pt + gate_pos;
															pt.IntoRect(rc);
															u.SetCommand("advance", pt);
														}
													}
												}
											}
										}
								}
								is_sieging = cataps_placed;
								Sleep(2000);
							}

							//step 3: clear catapults and advance to the target
							for (i = 0; i < ol_siegers.count; i += 1) {
								u = ol_siegers[i].AsUnit();
								if (u.IsValid)
									if (!u.hero.IsValid) {
										if (u.GetHolderSett().IsValid) {
											Catapult c;
											c = u.GetHolderSett().GetCentralBuilding().AsCatapult();
											if (c.IsValid)
												c.SetCommand("disband");
										}
										pt.Set(0, main_target.radius + rand(60));
										pt.Rot(rand(360));
										pt = pt + main_target_pos;
										pt.IntoRect(rc);
										u.SetCommand("advance", pt);
									}
							}

							//step 4: capture
							while (1) {
								ol_siegers = q_siegers.GetObjList();
								if (ol_siegers.count <= 0)
									return;
								if (!ol_siegers[0].IsEnemy(main_target))
									return;
								for (i = 0; i < ol_siegers.count; i += 1) {
									u = ol_siegers[i].AsUnit();
									if (u.IsValid)
										if (!u.hero.IsValid) {
											u_cmd = u.command;
											if (u_cmd == "idle") {//new units added to the group and heroes who are interrupted while capturing (normal units become "engage" instead)
												u.SetCommand("engage");
												u.AddCommand(false, "capture", main_target);
											}
											else if (u_cmd == "capture") {//chance to abort the capture and attack an enemy warrior nearby (ignore sentries)
												if (u.DistTo(main_target) <= 550) {
													if (rand(8) == 0) {//small chance in order to reduce the risk of interrupting the capture when the defender keeps training new units
														u_tmp = u.BestTargetInSquadSight("Military");
														if (u_tmp.IsValid)
															if (!u_tmp.IsSentry)
																u.SetCommand("advance", u_tmp.pos);
													}
												}
												else if (rand(2) == 0) {//good chance in order to reduce the risk of ignoring the enemy (for idle units and new ones added to the group)
													u_tmp = u.BestTargetInSquadSight("Military");
													if (u_tmp.IsValid)
														if (!u_tmp.IsSentry)
															u.SetCommand("advance", main_target_pos);
												}
											}
											else if (u_cmd == "engage") {//chance to interrupt the fight and either capture the target or move to it depending on the distance
												u_tmp = u.BestTargetInSquadSight("Military");
												if (!u_tmp.IsValid)
													if (u.DistTo(main_target) <= 400)
														u.SetCommand("capture", main_target);
													else
														u.SetCommand("move", main_target_pos);
												else if (u_tmp.IsSentry)
													if (u.DistTo(main_target) <= 400)
														u.SetCommand("capture", main_target);
													else
														u.SetCommand("move", main_target_pos);
												else if (u.DistTo(main_target) <= 350) {//shorter distance to reduce the risk of stopping fighting real enemies (not barracks-trained units)
													if (rand(5) == 0)
														u.SetCommand("capture", main_target);
												}
												else if (rand(15) == 0)//low chance to reduce the risk of a move-engage cycle
													u.SetCommand("move", main_target_pos);
											}
											else if (u_cmd == "move") {//when near, stop moving and start capture
												if (u.DistTo(main_target) <= 300) {
													u.SetCommand("engage");
													u.AddCommand(false, "capture", main_target);
												}
												else if (rand(3) == 0) {
													u_tmp = u.BestTargetInSquadSight("Military");
													if (u_tmp.IsValid)
														if (!u_tmp.IsSentry)
															u.SetCommand("advance", main_target_pos);
												}
											}
										}
								}
								Sleep(2000);
							}
						}
					}

					//step 1: wait for most heroes and unattached units to gather near the target
					while (1) {
						j = 0;
						ol_siegers = q_siegers.GetObjList();
						if (ol_siegers.count <= 0)
							return;
						if (!ol_siegers[0].IsEnemy(main_target))
							return;
						for (i = 0; i < ol_siegers.count; i += 1) {
							u = ol_siegers[i].AsUnit();
							if (u.IsValid)
								if (!u.hero.IsValid) {
									u_cmd = u.command;
									if (u.DistTo(main_target) > 1000) {
										if (u_cmd == "move") {
											u_tmp = u.BestTargetInSquadSight("Military");//ignore sentries but not the other warriors
											if (u_tmp.IsValid)
												if (!u_tmp.IsSentry)
													u.SetCommand("advance", main_target_pos);
										}
										else if (u_cmd == "engage") {
											u_tmp = u.BestTargetInSquadSight("Military");//avoid fighting sentries forever
											if (!u_tmp.IsValid)
												u.SetCommand("move", main_target_pos);
											else if (u_tmp.IsSentry)
												u.SetCommand("move", main_target_pos);
										}
										else if (u_cmd != "advance")
											u.SetCommand("advance", main_target_pos);
									}
									else {
										if (u_cmd != "capture")
											if (u_cmd != "engage") {
												u_tmp = u.BestTargetInSquadSight("Military");
												if (!u_tmp.IsValid)
													u.SetCommand("capture", main_target);
												else if (!u_tmp.IsSentry)//prevent melee units from advancing to sentries
													u.SetCommand("advance", u_tmp.pos);
												else
													u.SetCommand("capture", main_target);
											}
										j += 1;
										if (u.AsHero().IsValid)
											j += u.AsHero().army.count;
									}
								}
						}
						if (j >= ol_siegers.count * 2 / 3)
							break;
						Sleep(2000);
					}

					//step 2: capture
					while (1) {
						ol_siegers = q_siegers.GetObjList();
						if (ol_siegers.count <= 0)
							return;
						if (!ol_siegers[0].IsEnemy(main_target))
							return;
						for (j = 0; j < ol_siegers.count; j += 1) {
							u = ol_siegers[j].AsUnit();
							if (u.IsValid)
								if (!u.hero.IsValid) {
									u_cmd = u.command;
									if (u_cmd == "idle") {//new units added to the group and heroes who are interrupted while capturing (normal units become "engage" instead)
										u.SetCommand("engage");
										u.AddCommand(false, "capture", main_target);
									}
									else if (u_cmd == "capture") {//chance to abort the capture and attack an enemy warrior nearby (ignore sentries)
										if (u.DistTo(main_target) <= 550) {
											if (rand(8) == 0) {//small chance in order to reduce the risk of interrupting the capture when the defender keeps training new units
												u_tmp = u.BestTargetInSquadSight("Military");
												if (u_tmp.IsValid)
													if (!u_tmp.IsSentry)
														u.SetCommand("advance", u_tmp.pos);
											}
										}
										else if (rand(2) == 0) {//good chance in order to reduce the risk of ignoring the enemy (for idle units and new ones added to the group)
											u_tmp = u.BestTargetInSquadSight("Military");
											if (u_tmp.IsValid)
												if (!u_tmp.IsSentry)
													u.SetCommand("advance", main_target_pos);
										}
									}
									else if (u_cmd == "engage") {//chance to interrupt the fight and capture the target or move to it depending on the distance
										u_tmp = u.BestTargetInSquadSight("Military");
										if (!u_tmp.IsValid)
											if (u.DistTo(main_target) <= 400)
												u.SetCommand("capture", main_target);
											else
												u.SetCommand("move", main_target_pos);
										else if (u_tmp.IsSentry)
											if (u.DistTo(main_target) <= 400)
												u.SetCommand("capture", main_target);
											else
												u.SetCommand("move", main_target_pos);
										else if (u.DistTo(main_target) <= 350) {//shorter distance to reduce the risk of stopping fighting real enemies (not barracks-trained units)
											if (rand(5) == 0)
												u.SetCommand("capture", main_target);
										}
										else if (rand(15) == 0)//low chance to reduce the risk of a move-engage cycle
											u.SetCommand("move", main_target_pos);
									}
									else if (u_cmd == "move") {//when near, stop moving and start capture
										if (u.DistTo(main_target) <= 300) {
											u.SetCommand("engage");
											u.AddCommand(false, "capture", main_target);
										}
										else if (rand(3) == 0) {
											u_tmp = u.BestTargetInSquadSight("Military");
											if (u_tmp.IsValid)
												if (!u_tmp.IsSentry)
													u.SetCommand("advance", main_target_pos);
										}
									}
								}
						}
						Sleep(2000);
					}
				}
			}
	}
}