//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(teaching)) {
			Unit u;
			int teaching_level;

			if (IsResearched(.player, "Ancestral Knowledge"))
				teaching_level = GetConst("TeachingLevel2");
			else
				teaching_level = GetConst("TeachingLevel1");

			if (!.InHolder)
				u = .FindUnitBelowILevel(teaching_level);
			if (u.IsDead)
				while (!.Goto(pt, 0, 2000, false, -1)) {
					u = .FindUnitBelowILevel(teaching_level);
					if (u.IsAlive)
						break;
					if (.TimeWithoutWalking >= 2500)
						break;
				}

			if (u.IsAlive) {
				.AddCommand(true, "advance", pt);
				.AddCommand(true, "teach", u);
			}
		}

Sleep(15);//prevent possible loops with other commands