//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(cripple)) {
			Unit u;

			if (!.InHolder)
				u = .GetBestCrippleTarget();
			if (u.IsDead)
				while (!.Goto(pt, 0, 2000, false, -1)) {
					u = .GetBestCrippleTarget();
					if (u.IsAlive)
						break;
					if (.TimeWithoutWalking >= 2500)
						break;
				}

			if (u.IsAlive) {
				.AddCommand(true, "advance", pt);
				.AddCommand(true, "cripple", u);
			}
		}

Sleep(30);//prevent possible loops with other commands