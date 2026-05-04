//void, Obj This, Obj target

if (target.IsAlive) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive)
			if (target != this) {
				Unit u;

				u = target.AsUnit();

				if (u.IsValid) {
					if (u.InHolder) {
						Sleep(30);//prevent possible loops with other commands
						return;
					}
					if (!.CanSee(u)) {
						Sleep(30);//prevent possible loops with other commands
						return;
					}
				}

				while (!.Goto(target, 20, 2500, false, 10000)) {
					if (target.IsDead)
						break;
					if (u.IsValid) {
						if (u.InHolder)
							break;
						if (!.CanSee(u))
							break;
					}
				}
			}
}

Sleep(30);//prevent possible loops with other commands