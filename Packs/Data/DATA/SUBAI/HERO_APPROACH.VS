//void, Obj This, Obj target

if (target.IsAlive) {
	Hero this;

	this = This.AsHero();

	if (.IsValid)
		if (.IsAlive)
			if (target != this)
				if (target.AsUnit().IsValid) {
					Unit u;

					u = target.AsUnit();

					if (!u.InHolder)
						if (.CanSee(u))
							if (.army.Contains(u))
								.AddCommand(true, "move", u.pos);
							else {
								if (!.InHolder)
									if (.DistTo(u) < 100) {
										Sleep(30);//prevent possible loops with other commands
										return;
									}

								.FormSetupAndMoveTo(u.pos, 0, 0, true);

								while (.HasPath) {
									.FormKeepMoving(1500);
									if (u.IsDead)
										break;
									if (u.InHolder)
										break;
									if (!.CanSee(u))
										break;
									if (.army.Contains(u))
										break;
									if (.DistTo(u) < 100)
										break;
									.FormSetupAndMoveTo(u.pos, 0, 0, true);
								}
							}
				}
				else {
					if (!.InHolder)
						if (.DistTo(target) < 100) {
							Sleep(30);//prevent possible loops with other commands
							return;
						}

					.FormSetupAndMoveTo(target.pos, 0, 0, true);

					while (.HasPath) {
						if (target.IsDead)
							break;
						if (.DistTo(target) < 100)
							break;
						.FormKeepMoving(1500);
					}
				}
}

Sleep(30);//prevent possible loops with other commands