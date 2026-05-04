//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(cripple)) {
			Unit u;
			int i = 10;

			if (!.InHolder)
				u = .GetBestCrippleTarget();
			while (!.Goto(pt, 0, 2000, false, -1)) {
				u = .GetBestCrippleTarget();
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
				u = .GetBestCrippleTarget();
				i -= 1;
			}

			if (u.IsAlive) {
				.AddCommand(true, "cripple", pt);
				.AddCommand(true, "cripple", u);
			}
		}

Sleep(30);//prevent possible loops with other commands