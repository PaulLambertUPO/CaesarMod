//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(healing)) {
			Unit u;
			int i = 10;

			if (!.InHolder)
				u = .FindUnitToHeal();
			while (!.Goto(pt, 0, 2000, false, -1)) {
				u = .FindUnitToHeal();
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
				u = .FindUnitToHeal();
				i -= 1;
			}

			if (u.IsAlive) {
				.AddCommand(true, "heal", pt);
				.AddCommand(true, "heal", u);
			}
		}

Sleep(15);//prevent possible loops with other commands