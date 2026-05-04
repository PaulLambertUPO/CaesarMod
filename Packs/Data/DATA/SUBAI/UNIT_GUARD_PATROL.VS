//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		.SetParryMode(false);

		if (!.InHolder)
			.AddCommand(false, "guardpatrol", .pos);

		while (true) {
			if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
				.AddCommand(true, "guardpatrol", pt);
				.AddCommand(true, "guardengage");
				break;
			}
			if (.Goto(pt, 0, 2000, false, 0))
				break;
		}
	}

Sleep(30);//prevent possible loops with other commands