//void, str group_name, str gate_name

//WARNING: this script does not support multiple wall layers or repairs

Gate main_target;

main_target = GetNamedObj(gate_name).obj.AsGate();

if (main_target.IsValid) {
	Settlement set;
	Building hall;
	ObjList ol_siegers;

	set = main_target.settlement;
	hall = set.GetCentralBuilding();

	ol_siegers = Group(group_name).GetObjList();

	if (ol_siegers.count > 0)
		if (ol_siegers[0].IsEnemy(main_target)) {
			Unit u;
			Obj o;
			str cmd;
			rect rc;
			point pt, main_target_pos, hall_pos;
			int i, j;
			bool cataps_placed, is_sieging = false;

			rc = GetMapRect();
			main_target_pos = main_target.pos;
			hall_pos = hall.pos;

			//step 1: wait for most heroes and detached units to gather near the gate
			while (true) {
				ol_siegers = Group(group_name).GetObjList();
				if (ol_siegers.count <= 0)
					return;
				if (!ol_siegers[0].IsEnemy(main_target))
					return;
				j = 0;
				for (i = ol_siegers.count - 1; i >= 0; i -= 1) {
					u = ol_siegers[i].AsUnit();
					if (u.IsValid)
						if (u.IsAlive)
							if (u.hero.IsDead) {
								cmd = u.command;
								if (u.DistTo(main_target) > 1200) {
									if (cmd == "move") {
										o = u.BestTargetInSquadSightMisZeroDamage();
										if (o.IsAlive)
											if (!o.IsSentry)
												u.SetCommand("advance", main_target_pos);
									}
									else if (cmd == "engage") {
										o = u.BestTargetInSquadSightMisZeroDamage();
										if (o.IsDead)
											u.SetCommand("move", main_target_pos);
										else if (o.IsSentry)
											u.SetCommand("move", main_target_pos);
									}
									else if (cmd != "advance")
										u.SetCommand("advance", main_target_pos);
								}
								else {
									if (cmd != "idle")
										if (cmd != "engage")
											u.SetCommand("idle");
									j += 1;
									if (u.AsHero().IsValid)
										j += u.AsHero().army.count;
								}
							}
				}
				if (j >= ol_siegers.count * 2 / 3)
					break;
				Sleep(3000);
			}

			//step 2: siege to break the gate
			while (!main_target.IsBroken) {
				ol_siegers = Group(group_name).GetObjList();
				if (ol_siegers.count <= 0)
					return;
				if (!ol_siegers[0].IsEnemy(main_target))
					break;//use break instead of return in order to clear catapults (step 3)

				if (!is_sieging) {
					ol_siegers.Siege(main_target, MAX(1, ol_siegers.count / 20), 0);//max catapults
					is_sieging = true;
				}

				cataps_placed = false;
				for (i = ol_siegers.count - 1; i >= 0; i -= 1) {
					u = ol_siegers[i].AsUnit();
					if (u.IsValid)
						if (u.IsAlive)
							if (u.hero.IsDead)
								if (u.InHolder)
									cataps_placed = true;
								else {
									cmd = u.command;
									if (cmd == "build_catapult")
										cataps_placed = true;
									else if (cmd == "idle" || cmd == "stand_position") {
										//for some reason, units sometimes do not attack the gate by calling the Siege function (it seems to happen with multiple heroes)
										if (u.AsHero().IsValid)
											u.SetCommand("attack", main_target);
										else if (u.IsRanged)
											u.SetCommand("attack", main_target);
										else {
											//advance to a point that is not too close to the gate
											pt = u.pos - main_target_pos;
											j = MAX(1, pt.Len);
											if (j < 900) {
												pt = pt * (900 + rand(101)) / j + main_target_pos;
												pt.IntoRect(rc);
												u.SetCommand("advance", pt);
											}
											else if (j > 1000) {
												pt = pt * (900 + rand(101)) / j + main_target_pos;
												pt.IntoRect(rc);
												u.SetCommand("advance", pt);
											}
										}
									}
								}
				}
				is_sieging = cataps_placed;
				Sleep(3000);
			}

			//step 3: clear catapults and advance to the hall
			j = hall.radius;
			for (i = ol_siegers.count - 1; i >= 0; i -= 1) {
				u = ol_siegers[i].AsUnit();
				if (u.IsValid)
					if (u.IsAlive)
						if (u.hero.IsDead) {
							if (u.GetHolderSett().IsValid) {
								Catapult c;
								c = u.GetHolderSett().GetCentralBuilding().AsCatapult();
								if (c.IsValid)
									c.SetCommand("stop");
							}
							pt.Set(0, j + rand(60));
							pt.Rot(rand(360));
							pt = pt + hall_pos;
							pt.IntoRect(rc);
							u.SetCommand("advance", pt);
						}
			}
			Sleep(3000);

			//step 4: capture
			while (true) {
				ol_siegers = Group(group_name).GetObjList();
				if (ol_siegers.count <= 0)
					return;
				if (!ol_siegers[0].IsEnemy(hall))
					return;
				for (i = ol_siegers.count - 1; i >= 0; i -= 1) {
					u = ol_siegers[i].AsUnit();
					if (u.IsValid)
						if (u.IsAlive)
							if (u.hero.IsDead) {
								cmd = u.command;
								if (cmd == "idle") {//new units added to the group and heroes who are interrupted while capturing (normal units use "engage" instead)
									if (u.DistTo(hall) <= 400)
										u.SetCommand("engage");
									else
										u.SetCommand("advance", hall_pos);
									u.AddCommand(false, "capture", hall);
								}
								else if (cmd == "stand_position") {//hero armies (see "hero_move.vs")
									if (u.DistTo(hall) <= 400)
										u.SetCommand("engage");
									else
										u.SetCommand("advance", hall_pos);
									u.AddCommand(false, "capture", hall);
								}
								else if (cmd == "capture") {//chance to abort the capture and attack an enemy nearby (ignore sentries and spammed barracks units)
									if (u.DistTo(hall) <= 300) {
										if (rand(6) == 0) {
											o = u.BestTargetInSquadSightMisZeroDamage();
											if (o.IsAlive)
												if (!o.IsSentry) {
													if (o.AsUnit().IsValid)
														if (o.AsUnit().hero.IsDead)
															if (o.IsRanged) {//shorter ranges for archers because they do not need to move much to attack after being recruited
																if (ObjsInRange(o, "BaseBarracks", 80).count > 0)
																	if (ObjsInRange(o, o.class, 100).count < 6)
																		if (Intersect(ObjsInSight(hall, "Military"), FriendlyObjs(hall.player, "Military")).count < 10)
																			continue;
															}
															else if (ObjsInRange(o, "BaseBarracks", 120).count > 0)
																if (ObjsInRange(o, o.class, 150).count < 6)
																	if (Intersect(ObjsInSight(hall, "Military"), FriendlyObjs(hall.player, "Military")).count < 10)
																		continue;
													u.SetCommand("advance", o.pos);
												}
										}
									}
									else if (rand(2) == 0) {//good chance in order to reduce the risk of ignoring the enemy (for idle units and new ones added to the group)
										o = u.BestTargetInSquadSightMisZeroDamage();
										if (o.IsAlive)
											if (!o.IsSentry)
												u.SetCommand("advance", hall_pos);
									}
								}
								else if (cmd == "engage") {//chance to abort the fight and either capture the hall or move to it depending on the distance
									o = u.BestTargetInSquadSightMisZeroDamage();
									if (o.IsDead)
										if (u.DistTo(hall) <= 400)
											u.SetCommand("capture", hall);
										else
											u.SetCommand("move", hall_pos);
									else if (o.IsSentry)
										if (u.DistTo(hall) <= 400)
											u.SetCommand("capture", hall);
										else
											u.SetCommand("move", hall_pos);
									else if (u.DistTo(hall) <= 400) {
										if (rand(2) == 0)//few spammed barracks units should not be considered much to avoid fighting forever
											if (o.AsUnit().IsValid)
												if (o.AsUnit().hero.IsDead)
													if (o.IsRanged) {//shorter ranges for archers because they do not need to move much to attack
														if (ObjsInRange(o, "BaseBarracks", 80).count > 0)
															if (ObjsInRange(o, o.class, 100).count < 6)
																if (Intersect(VisibleObjsInSight(hall, "Military"), FriendlyObjs(hall.player, "Military")).count < 10) {
																	u.SetCommand("capture", hall);
																	continue;
																}
													}
													else if (ObjsInRange(o, "BaseBarracks", 120).count > 0)
														if (ObjsInRange(o, o.class, 150).count < 6)
															if (Intersect(VisibleObjsInSight(hall, "Military"), FriendlyObjs(hall.player, "Military")).count < 10) {
																u.SetCommand("capture", hall);
																continue;
															}
										if (rand(14) == 0)
											u.SetCommand("capture", hall);
									}
									else if (rand(25) == 0)//very low chance to reduce the risk of a move-engage cycle
										u.SetCommand("move", hall_pos);
								}
								else if (cmd == "move")//when near, stop moving and start capturing
									if (u.DistTo(hall) <= 400) {
										u.SetCommand("engage");
										u.AddCommand(false, "capture", hall);
									}
									else if (rand(2) == 0) {
										o = u.BestTargetInSquadSightMisZeroDamage();
										if (o.IsAlive)
											if (!o.IsSentry)
												u.SetCommand("advance", hall_pos);
									}
							}
				}
				Sleep(3000);
			}
		}
}