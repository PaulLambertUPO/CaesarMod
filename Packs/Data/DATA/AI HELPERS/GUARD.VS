//void, str GroupName, str Target

Settlement set;

set = GetSettlement(Target);

if (set.IsValid) {
	Building main_target;

	main_target = set.GetCentralBuilding();

	if (main_target.IsValid) {
		Query q_guards;
		ObjList ol_guards, enemies;
		Unit u;
		point main_target_pos;
		str u_cmd;
		int i, j;

		main_target_pos = main_target.pos;
		q_guards = Group(GroupName);
		ol_guards = q_guards.GetObjList();

		if (set.IsStronghold)
			while (1) {
				ol_guards = q_guards.GetObjList();
				if (ol_guards.count <= 0)
					return;
				if (ol_guards[0].IsEnemy(main_target))
					return;
				enemies = Intersect(
					Union(VisibleObjsInSight(main_target, "Unit"), ObjsInRange(main_target, "Catapult", 1200)),
					Union(EnemyObjs(main_target.player, "Unit"), EnemyObjs(main_target.player, "Catapult"))
				).GetObjList();
				for (i = 0; i < ol_guards.count; i += 1) {
					u = ol_guards[i].AsUnit();
					if (u.IsValid)
						if (!u.hero.IsValid)
							if (u.InHolder) {
								if (enemies.count > 0)
									u.SetCommand("advance", enemies[0].pos);
							}
							else {
								j = u.DistTo(main_target_pos);
								u_cmd = u.command;
								if (j >= 1150) {
									if (u_cmd != "enter")
										u.SetCommand("enter", main_target); 
								}
								else if (j >= 750) {
									if (u_cmd != "enter")
										if (u_cmd != "advance")
											if (u_cmd != "advanceenter")
												if (u_cmd != "engage")
													if (enemies.count > 0)
														u.SetCommand("advance", enemies[0].pos);
													else
														u.SetCommand("advanceenter", main_target);
								}
								else if (u_cmd != "advanceenter")
									if (u_cmd != "advance")
										if (u_cmd != "engage")
											if (enemies.count > 0)
												u.SetCommand("advance", enemies[0].pos);
											else
												u.SetCommand("advanceenter", main_target);
							}
				}
				Sleep(2000);
			}
		else if (set.IsOutpost)
			while (1) {
				ol_guards = q_guards.GetObjList();
				if (ol_guards.count <= 0)
					return;
				if (ol_guards[0].IsEnemy(main_target))
					return;
				enemies = Intersect(
					Union(VisibleObjsInSight(main_target, "Unit"), ObjsInRange(main_target, "Catapult", 1200)),
					Union(EnemyObjs(main_target.player, "Unit"), EnemyObjs(main_target.player, "Catapult"))
				).GetObjList();
				for (i = 0; i < ol_guards.count; i += 1) {
					u = ol_guards[i].AsUnit();
					if (u.IsValid)
						if (!u.hero.IsValid)
							if (u.InHolder) {
								if (enemies.count > 0)
									u.SetCommand("advance", enemies[0].pos);
							}
							else {
								j = u.DistTo(main_target_pos);
								u_cmd = u.command;
								if (j >= 1450) {
									if (u_cmd != "enter")
										u.SetCommand("enter", main_target); 
								}
								else if (j >= 1050) {
									if (u_cmd != "enter")
										if (u_cmd != "advance")
											if (u_cmd != "advanceenter")
												if (u_cmd != "engage")
													if (enemies.count > 0)
														u.SetCommand("advance", enemies[0].pos);
													else
														u.SetCommand("advanceenter", main_target);
								}
								else if (u_cmd != "advanceenter")
									if (u_cmd != "advance")
										if (u_cmd != "engage")
											if (enemies.count > 0)
												u.SetCommand("advance", enemies[0].pos);
											else
												u.SetCommand("advanceenter", main_target);
							}
				}
				Sleep(2000);
			}
		else
			while (1) {
				ol_guards = q_guards.GetObjList();
				if (ol_guards.count <= 0)
					return;
				if (ol_guards[0].IsEnemy(main_target))
					return;
				enemies = Intersect(
					Union(VisibleObjsInSight(main_target, "Unit"), ObjsInRange(main_target, "Catapult", 1200)),
					Union(EnemyObjs(main_target.player, "Unit"), EnemyObjs(main_target.player, "Catapult"))
				).GetObjList();
				for (i = 0; i < ol_guards.count; i += 1) {
					u = ol_guards[i].AsUnit();
					if (u.IsValid)
						if (!u.hero.IsValid) {
							j = u.DistTo(main_target_pos);
							u_cmd = u.command;
							if (j >= 1100) {
								if (u_cmd != "move")
									u.SetCommand("move", main_target_pos); 
							}
							else if (j >= 700) {
								if (u_cmd != "move")
									if (u_cmd != "advance")
										if (u_cmd != "engage")
											if (enemies.count > 0)
												u.SetCommand("advance", enemies[0].pos);
											else
												u.SetCommand("advance", main_target_pos);
							}
							else if (u_cmd != "advance")
								if (u_cmd != "engage")
									if (enemies.count > 0)
										u.SetCommand("advance", enemies[0].pos);
									else if (j >= 150)
										u.SetCommand("advance", main_target_pos);
						}
				}
				Sleep(2000);
			}
	}
}