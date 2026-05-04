//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Hero h;

		if (.AI)
			.SetParryMode(false);

		h = .hero;

		if (h.IsValid)
			if (.InShip)
				.DetachFrom(h);//avoid slowing down the hero and the army
			else {
				.FormAcceptMove();

				while (.HasPath)
					.FormKeepMoving(1000);

				if (.hero == h)
					if (h.IsAlive) {
						point pt_dir;

						pt_dir = h.GetFinalPartyOrientation() - Point(1024, 1024);

						if (pt_dir.x == 0)
							if (pt_dir.y == 0)
								pt_dir = h.GetDir();

						.Face(.pos + pt_dir);
					}
			}
	}

Sleep(30);//prevent possible loops with other commands