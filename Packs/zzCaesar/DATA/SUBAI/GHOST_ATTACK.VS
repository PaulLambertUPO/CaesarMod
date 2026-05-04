//void, Obj This, Obj target

Ghost this;

this = This.AsGhost();

if (.IsValid)
	if (.IsAlive) {
		Unit u;

		if (.GetAnim() == 17)//spawn
			Sleep(.TimeToAnimFinish);

		u = target.AsUnit();

		if (u.IsValid)
			if (u.IsAlive)
				if (.IsEnemy(u))
					if (!u.InHolder)
						if (.CanSee(u))
							while (!.Goto(u, .range - 20, 3000, false, 0)) {
								if (u.IsDead)
									break;
								if (!.IsEnemy(u))
									break;
								if (u.InHolder)
									break;
								if (!.CanSee(u))
									break;
							}
	}

Sleep(30);//prevent possible loops with other commands