//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		.SetParryMode(false);

		while (true) {
			if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
				.AddCommand(true, "guard_advance", pt);
				.AddCommand(true, "guard_engage");
				break;
			}
			if (.Goto(pt, 0, 2000, false, 0))
				break;
		}
	}

Sleep(30);//prevent possible loops with other commands