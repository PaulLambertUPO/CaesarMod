//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		Unit u;
		int i = 10;

		if (!.InHolder)
			u = .FindUnitToLearn();
		while (!.Goto(pt, 0, 2000, false, -1)) {
			u = .FindUnitToLearn();
			if (u.IsAlive)
				if (.DistTo(pt) < .sight)
					break;
			if (.TimeWithoutWalking >= 2500)
				break;
		}

		while (i > 0) {
			if (u.IsAlive)
				break;
			Sleep(500);
			u = .FindUnitToLearn();
			i -= 1;
		}

		if (u.IsAlive) {
			.AddCommand(true, "learn", pt);
			.AddCommand(true, "learn", u);
		}
	}

Sleep(30);//prevent possible loops with other commands