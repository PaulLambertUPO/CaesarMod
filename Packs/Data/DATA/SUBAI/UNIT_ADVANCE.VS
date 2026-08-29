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
			if (.Goto(pt, 0, 2000, false, 1500))//do not use this condition for the loop and keep it here otherwise there are problems with "unit_idle.vs"
				break;
		}
	}

Sleep(30);//prevent possible loops with other commands