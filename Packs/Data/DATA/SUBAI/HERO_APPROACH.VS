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
								point target_pos;

								if (!.InHolder)
									if (.DistTo(u) < 100) {
										Sleep(30);//prevent possible loops with other commands
										return;
									}

								target_pos = u.pos;
								.FormSetupAndMoveTo(target_pos, 0, 0, true);

								while (.HasPath) {
									.FormKeepMoving(1000);
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
									if (u.DistTo(target_pos) > 350) {//avoid moving the army every time or it risks messing up with obstacles nearby
										target_pos = u.pos;
										.FormSetupAndMoveTo(target_pos, 0, 0, true);
									}
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
						.FormKeepMoving(1000);
					}
				}
}

Sleep(30);//prevent possible loops with other commands