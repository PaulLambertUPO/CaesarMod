//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive)
		if (.HasFinalPartyOrientationRequest)
			.AddCommand(true, "move", pt);
		else {
			while (!.Goto(pt, 0, 2000, false, 0))
				;

			if (.HasArmy)
				Sleep(7000);
			else
				.AddCommand(true, "stand_position");
		}