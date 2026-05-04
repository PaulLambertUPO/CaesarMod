//void, Obj This

Ghost this;

this = This.AsGhost();

if (.IsValid)
	if (.IsAlive) {
		ObjList ol_enemies;

		if (.GetAnim() == 17)//spawn
			Sleep(.TimeToAnimFinish);

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(10000);
			else if (.Stop(2000)) {
				ol_enemies = Intersect(VisibleObjsInSight(this, "Military,Peaceful"), EnemyObjs(.player, "Unit")).GetObjList();

				if (ol_enemies.count > 0) {//move to the central point among enemies that can be damaged
					Obj o;
					point pt_move;
					int i, j;

					for (i = ol_enemies.count - 1; i >= 0; i -= 1) {
						o = ol_enemies[i];
						if (o.IsAlive)
							if (o.health > o.maxhealth / 5) {
								pt_move = pt_move + o.pos;
								j += 1;
							}
					}

					if (j > 0) {
						pt_move = pt_move / j;
						if (.DistTo(pt_move) > 60) {
							.AddCommand(true, "move", pt_move);
							break;
						}
					}
				}

				.Idle(1500);
			}
	}

Sleep(30);//prevent possible loops with other commands