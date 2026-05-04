//void, Obj This, Obj other

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Ship sh;

		sh = other.AsShip();

		if (sh.IsValid)
			if (sh.IsAlive)
				if (DiplGetShareControl(sh.player, .player))
					if (sh.UnitsCount < sh.UnitsMax) {
						if (!.InShip) {
							sh.NotifyBoardUnit(this);
							if (sh.DistTo(.posRH) >= 600) {
								.FormSetupAndMoveTo(sh.pos, 0, 0, false);
								while (.HasPath) {
									.FormKeepMoving(1500);
									if (sh.IsDead)
										break;
									if (.DistTo(sh) < 600)
										break;
									.FormSetupAndMoveTo(sh.pos, 0, 0, false);
								}
							}
							.AddCommand(true, "boardshipcommon", sh);
						}
						.army.SetCommand("boardship", sh);
					}
	}

Sleep(30);//prevent possible loops with other commands