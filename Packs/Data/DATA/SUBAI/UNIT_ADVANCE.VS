//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		if (IsAIPlayer(.player))
			.SetParryMode(false);

		while (1) {
			if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
				.AddCommand(true, "advance", pt);
				.AddCommand(true, "engage");
				break;
			}
			if (.Goto(pt, 0, 2000, false, 0))//do not use this condition for the loop and keep it here otherwise there are problems with "unit_idle.vs"
				break;
		}
	}

Sleep(15);//prevent possible loops with other commands