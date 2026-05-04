//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		if (.AI)
			.SetParryMode(false);

		while (true) {
			if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
				.AddCommand(true, "advance", pt);
				.AddCommand(true, "engage");
				break;
			}
			if (.Goto(pt, 0, 2000, false, 0))
				break;
		}
	}

Sleep(30);//prevent possible loops with other commands