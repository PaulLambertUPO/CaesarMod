//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building target;

		while (true) {
			target = .RamBestTarget.AsBuilding();

			if (target.IsValid)
				if (!target.IsVeryBroken) {
					.AddCommand(true, "advance", pt);
					.AddCommand(true, "attack", target);
					break;
				}

			if (.Goto(pt, 0, 2000, false, 0))
				break;
		}
	}

Sleep(30);//prevent possible loops with other commands