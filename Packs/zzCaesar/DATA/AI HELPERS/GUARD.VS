//void, str group_name, str set_name

Settlement set;

set = GetSettlement(set_name);

if (set.IsValid) {
	Building main_target;
	ObjList ol_guards, enemies;
	Unit u;
	point main_target_pos;
	str cmd;
	int i, j;

	main_target = set.GetCentralBuilding();

	main_target_pos = main_target.pos;

	if (set.IsStronghold)
		while (true) {
			ol_guards = Group(group_name).GetObjList();
			if (ol_guards.count <= 0)
				return;
			if (ol_guards[0].IsEnemy(main_target))
				return;
			enemies = Intersect(
				Union(VisibleObjsInSight(main_target, "Military,Peaceful,AttackAnimal,GGhostUnit"), ObjsInRange(main_target, "Catapult", 1200)),
				Union(EnemyObjs(main_target.player, "Unit"), EnemyObjs(main_target.player, "Catapult"))
			).GetObjList();
			for (i = ol_guards.count - 1; i >= 0; i -= 1) {
				u = ol_guards[i].AsUnit();
				if (u.IsValid)
					if (u.IsAlive)
						if (u.hero.IsDead)
							if (u.InHolder) {
								if (enemies.count > 0)
									u.SetCommand("advance_aggressive", enemies[0].posRH);
							}
							else {
								j = u.DistTo(main_target_pos);
								cmd = u.command;
								if (j >= 1250) {
									if (cmd != "enter")
										u.SetCommand("enter", main_target);
								}
								else if (j >= 750) {
									if (cmd != "enter")
										if (cmd != "advance_aggressive")
											if (cmd != "advanceenter")
												if (cmd != "engage")
													if (enemies.count > 0)
														u.SetCommand("advance_aggressive", enemies[0].posRH);
													else
														u.SetCommand("advanceenter", main_target);
								}
								else if (cmd != "advanceenter")
									if (cmd != "advance_aggressive")
										if (cmd != "engage")
											if (enemies.count > 0)
												u.SetCommand("advance_aggressive", enemies[0].posRH);
											else
												u.SetCommand("advanceenter", main_target);
							}
			}
			Sleep(3000);
		}
	else if (set.IsOutpost)
		while (true) {
			ol_guards = Group(group_name).GetObjList();
			if (ol_guards.count <= 0)
				return;
			if (ol_guards[0].IsEnemy(main_target))
				return;
			enemies = Intersect(
				Union(VisibleObjsInSight(main_target, "Military,Peaceful,AttackAnimal,GGhostUnit"), ObjsInRange(main_target, "Catapult", 1200)),
				Union(EnemyObjs(main_target.player, "Unit"), EnemyObjs(main_target.player, "Catapult"))
			).GetObjList();
			for (i = ol_guards.count - 1; i >= 0; i -= 1) {
				u = ol_guards[i].AsUnit();
				if (u.IsValid)
					if (u.IsAlive)
						if (u.hero.IsDead)
							if (u.InHolder) {
								if (enemies.count > 0)
									u.SetCommand("advance_aggressive", enemies[0].posRH);
							}
							else {
								j = u.DistTo(main_target_pos);
								cmd = u.command;
								if (j >= 1450) {
									if (cmd != "enter")
										u.SetCommand("enter", main_target);
								}
								else if (j >= 1050) {
									if (cmd != "enter")
										if (cmd != "advance_aggressive")
											if (cmd != "advanceenter")
												if (cmd != "engage")
													if (enemies.count > 0)
														u.SetCommand("advance_aggressive", enemies[0].posRH);
													else
														u.SetCommand("advanceenter", main_target);
								}
								else if (cmd != "advanceenter")
									if (cmd != "advance_aggressive")
										if (cmd != "engage")
											if (enemies.count > 0)
												u.SetCommand("advance_aggressive", enemies[0].posRH);
											else
												u.SetCommand("advanceenter", main_target);
							}
			}
			Sleep(3000);
		}
	else
		while (true) {
			ol_guards = Group(group_name).GetObjList();
			if (ol_guards.count <= 0)
				return;
			if (ol_guards[0].IsEnemy(main_target))
				return;
			enemies = Intersect(
				Union(VisibleObjsInSight(main_target, "Military,Peaceful,AttackAnimal,GGhostUnit"), ObjsInRange(main_target, "Catapult", 1200)),
				Union(EnemyObjs(main_target.player, "Unit"), EnemyObjs(main_target.player, "Catapult"))
			).GetObjList();
			for (i = ol_guards.count - 1; i >= 0; i -= 1) {
				u = ol_guards[i].AsUnit();
				if (u.IsValid)
					if (u.IsAlive)
						if (u.hero.IsDead) {
							j = u.DistTo(main_target_pos);
							cmd = u.command;
							if (j >= 1250) {
								if (cmd != "move")
									u.SetCommand("move", main_target_pos);
							}
							else if (j >= 700) {
								if (cmd != "move")
									if (cmd != "advance_aggressive")
										if (cmd != "engage")
											if (enemies.count > 0)
												u.SetCommand("advance_aggressive", enemies[0].posRH);
											else
												u.SetCommand("advance_aggressive", main_target_pos);
							}
							else if (cmd != "advance_aggressive")
								if (cmd != "engage")
									if (enemies.count > 0)
										u.SetCommand("advance_aggressive", enemies[0].posRH);
									else if (j >= 400)
										u.SetCommand("advance_aggressive", main_target_pos);
						}
			}
			Sleep(3000);
		}
}