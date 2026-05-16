//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(teaching)) {
			Unit u;
			int teaching_level, i = 10;

			if (IsResearched(.player, "Ancestral Knowledge"))
				teaching_level = GetConst("TeachingLevel2");
			else
				teaching_level = GetConst("TeachingLevel1");

			if (!.InHolder)
				u = .FindUnitBelowILevel(teaching_level);
			while (!.Goto(pt, 0, 2000, false, -1)) {
				u = .FindUnitBelowILevel(teaching_level);
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
				u = .FindUnitBelowILevel(teaching_level);
				i -= 1;
			}

			if (u.IsAlive) {
				.AddCommand(true, "teach", pt);
				.AddCommand(true, "teach", u);
			}
		}

Sleep(30);//prevent possible loops with other commands