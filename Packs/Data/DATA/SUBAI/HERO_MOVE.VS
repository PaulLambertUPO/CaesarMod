//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		point pt_dir;

		.FormSetupAndMoveTo(pt, 0, 0, true);

		while (.HasPath)
			.FormKeepMoving(1500);

		pt_dir = .GetFinalPartyOrientation() - Point(1024, 1024);

		if (pt_dir.x != 0)
			.Face(.pos + pt_dir);
		else if (pt_dir.y != 0)
			.Face(.pos + pt_dir);

		if (.HasArmy)
			if (.CmdCount <= 1)
				.AddCommand(true, "stand_position");
	}

Sleep(30);//prevent possible loops with other commands