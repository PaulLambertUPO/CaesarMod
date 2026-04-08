//void, Obj This

Ship this;

this = This.AsShip();

if (.IsValid)
	if (.IsAlive) {
		if (.IsBuilding) {
			while (.IsBuilding)
				Sleep(200);
			while (!.Goto(.FindPointToStay(), 0, 2000, false, -1))//use -1 with the inner check because there is something strange with ships
				if (.TimeWithoutWalking > 0)
					break;
		}
		else {
			while (!.Stop(2000))
				;
			Sleep(100 + rand(101));
		}

		while (true) {
			if (.HasAiTransport)
				if (.UnitsCount <= 0)
					.ClearAiTransport();
				else {
					.AddCommand(true, "aitransport");
					break;
				}

			if (.IsVisible)
				if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
					.AddCommand(true, "advance", .pos);
					break;
				}

			if (.Stop(2000))
				.Idle();
		}
	}

Sleep(15);//prevent possible loops with other commands