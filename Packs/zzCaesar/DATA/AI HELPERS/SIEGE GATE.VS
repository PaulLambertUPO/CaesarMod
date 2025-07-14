//void, str GroupName, str Target

//note: this script does not manage multiple gates or repairs

Gate main_target;

main_target = GetNamedObj(Target).obj.AsGate();

if (main_target.IsValid) {
	Settlement set;

	set = main_target.settlement;

	if (set.IsValid) {
		Building hall;

		hall = set.GetCentralBuilding();

		if (hall.IsValid) {
			Query q_siegers;
			ObjList ol_siegers;

			q_siegers = Group(GroupName);
			ol_siegers = q_siegers.GetObjList();

			if (ol_siegers.count > 0)
				if (ol_siegers[0].IsEnemy(main_target)) {
					Unit u, u_tmp;
					str u_cmd;
					rect rc;
					point pt, main_target_pos, hall_pos;
					int i, j;
					bool cataps_placed, is_sieging = false;

					rc = GetMapRect();
					main_target_pos = main_target.pos;
					hall_pos = hall.pos;

					//step 1: wait for most heroes and unattached units to gather near the gate
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
									if (u.DistTo(main_target) > 1200) {
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

					//step 2: siege to break the gate
					while (!main_target.IsBroken) {
						ol_siegers = q_siegers.GetObjList();
						if (ol_siegers.count <= 0)
							return;
						if (!ol_siegers[0].IsEnemy(main_target))
							break;//use break instead of return in order to clear catapults (step 3)

						if (!is_sieging) {
							ol_siegers.Siege(main_target, MAX(1, ol_siegers.count / 20), 0);//max catapults
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
												u.SetCommand("attack", main_target);
											else if (u.IsRanged)
												u.SetCommand("attack", main_target);
											else {
												//advance to a point that is not too close to the gate
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
										}
									}
								}
						}
						is_sieging = cataps_placed;
						Sleep(2000);
					}

					//step 3: clear catapults
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
								pt.Set(0, hall.radius + rand(60));
								pt.Rot(rand(360));
								pt = pt + hall_pos;
								pt.IntoRect(rc);
								u.SetCommand("advance", pt);
							}
					}

					//step 4: capture
					while (1) {
						ol_siegers = q_siegers.GetObjList();
						if (ol_siegers.count <= 0)
							return;
						if (!ol_siegers[0].IsEnemy(hall))
							return;
						for (i = 0; i < ol_siegers.count; i += 1) {
							u = ol_siegers[i].AsUnit();
							if (u.IsValid)
								if (!u.hero.IsValid) {
									u_cmd = u.command;
									if (u_cmd == "idle") {//new units added to the group and heroes who are interrupted while capturing (normal units become "engage" instead)
										u.SetCommand("engage");
										u.AddCommand(false, "capture", hall);
									}
									else if (u_cmd == "capture") {//chance to abort the capture and attack an enemy warrior nearby (ignore sentries)
										if (u.DistTo(hall) <= 550) {
											if (rand(8) == 0) {//low chance in order to reduce the risk of interrupting the capture when the defender keeps training new units
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
													u.SetCommand("advance", hall_pos);
										}
									}
									else if (u_cmd == "engage") {//chance to interrupt the fight and either capture the target or move to it depending on the distance
										u_tmp = u.BestTargetInSquadSight("Military");
										if (!u_tmp.IsValid)
											if (u.DistTo(hall) <= 400)
												u.SetCommand("capture", hall);
											else
												u.SetCommand("move", hall_pos);
										else if (u_tmp.IsSentry)
											if (u.DistTo(hall) <= 400)
												u.SetCommand("capture", hall);
											else
												u.SetCommand("move", hall_pos);
										else if (u.DistTo(hall) <= 350) {//shorter distance to reduce the risk of stopping fighting real enemies (not barracks-trained units)
											if (rand(5) == 0)
												u.SetCommand("capture", hall);
										}
										else if (rand(15) == 0)//low chance to reduce the risk of a move-engage cycle
											u.SetCommand("move", hall_pos);
									}
									else if (u_cmd == "move") {//when near, stop moving and start capture
										if (u.DistTo(hall) <= 300) {
											u.SetCommand("engage");
											u.AddCommand(false, "capture", hall);
										}
										else if (rand(3) == 0) {
											u_tmp = u.BestTargetInSquadSight("Military");
											if (u_tmp.IsValid)
												if (!u_tmp.IsSentry)
													u.SetCommand("advance", hall_pos);
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