//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		point pt_pos;

		if (IsAIPlayer(.player))
			.SetParryMode(false);

		while (!.Goto(pt, 0, 2000, false, -1))
			if (.TimeWithoutWalking > 0)
				break;

		pt_pos = .pos;
		pt = .GetUnexploredPoint(-1);

		while (pt.x != -1) {
			while (!.Goto(pt, 0, 2000, false, -1))
				if (.TimeWithoutWalking > 0)
					break;

			if (pt_pos == .pos)
				break;

			pt_pos = .pos;
			pt = .GetUnexploredPoint(-1);
		}
	}

Sleep(15);//prevent possible loops with other commands