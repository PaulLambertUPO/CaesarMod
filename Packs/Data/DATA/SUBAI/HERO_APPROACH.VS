//void, Obj This, Obj target

if (target.IsAlive) {
	Hero this;

	this = This.AsHero();

	if (.IsValid)
		if (.IsAlive) {
			Unit u;

			u = target.AsUnit();

			if (u.IsValid) {
				if (u.InHolder) {
					Sleep(15);//prevent possible loops with other commands
					return;
				}
				.FormSetupAndMoveTo(target, 0, 0, false);
			}
			else
				.FormSetupAndMoveTo(target.pos, 0, 0, false);

			while (target.IsAlive) {
				if (u.IsValid)
					if (u.InHolder)
						break;
				if (!.HasPath)
					break;
				if (.DistTo(target) < 100)
					break;
				.FormKeepMoving(1500);
			}
		}
}

Sleep(15);//prevent possible loops with other commands