//void, Obj This, Obj target

if (target.IsAlive) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive) {
			Unit u;

			u = target.AsUnit();

			if (u.IsValid)
				if (u.InHolder) {
					Sleep(15);//prevent possible loops with other commands
					return;
				}

			while (!.Goto(target, 20, 2500, false, 10000)) {
				if (target.IsDead)
					break;
				if (u.IsValid)
					if (u.InHolder)
						break;
			}
		}
}

Sleep(15);//prevent possible loops with other commands