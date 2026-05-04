//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		point pt_pos;

		.FormSetupAndMoveTo(pt, 0, 0, true);

		while (.HasPath)
			.FormKeepMoving(1500);

		pt_pos = .pos;
		pt = .GetUnexploredPoint(-1);

		while (pt.x != -1) {
			.FormSetupAndMoveTo(pt, 0, 0, true);

			while (.HasPath)
				.FormKeepMoving(1500);

			if (pt_pos == .pos)
				break;

			pt_pos = .pos;
			pt = .GetUnexploredPoint(-1);
		}
	}

Sleep(30);//prevent possible loops with other commands