//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Obj o;

		.FormSetupAndMoveTo(pt, 0, 0, true);

		while (!.IsArmyOutside)
			.FormKeepMoving(500);

		while (.HasPath) {
			o = .BestTargetInSquadSightMisZeroDamage;
			if (o.IsAlive)
				if (!o.IsSentry)
					if (o.pos.Dist(pt) < .sight / 2) {
						.AddCommand(true, "advance", pt);
						break;
					}
					else if (.IsValidTarget(o)) {
						.AddCommand(true, "sneak", pt);
						.AddCommand(true, "engage");
						break;
					}
			.FormKeepMoving(1500);
		}
	}

Sleep(15);//prevent possible loops with other commands