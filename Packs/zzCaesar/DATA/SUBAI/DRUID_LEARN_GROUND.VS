//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		int i;

		i = .race;

		if (i == Gaul) {
			if (IsResearched(.player, "Ritual Chamber"))
				i = 10;
		}
		else if (i == Britain) {
			if (IsResearched(.player, "Ritual Chamber"))
				i = 10;
		}
		else if (i == Germany) {
			if (IsResearched(.player, "Ritual Chamber"))
				i = 10;
		}
		else
			i = 10;

		if (i == 10) {
			Unit u;

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
	}

Sleep(15);//prevent possible loops with other commands