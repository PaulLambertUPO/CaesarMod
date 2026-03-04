//void, Obj me

Ship this;

this = me.AsShip();

if (.IsValid)
	if (.IsAlive) {
		if (.IsBuilding) {
			while (.IsBuilding)
				Sleep(100);
			while (!.Goto(.FindPointToStay(), 0, 2000, false, -1))//use -1 with the inner check because there is something strange with ships
				if (.TimeWithoutWalking > 0)
					break;
		}
		else {
			while (!.Stop(50))
				;
			Sleep(100 + rand(101));
		}

		while (1) {
			if (.HasAiTransport)
				if (.UnitsCount <= 0)
					.ClearAiTransport();
				else {
					.AddCommand(true, "aitransport");
					break;
				}

			if (.BestTargetInSquadSight().IsAlive) {
				.AddCommand(true, "advance", .pos);
				break;
			}
			else if (.Stop(200))
				.Idle();
		}
	}

Sleep(15);//prevent possible loops with other commands