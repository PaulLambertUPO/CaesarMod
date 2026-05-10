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
								point target_pos;

								target_pos = sh.pos;
								.FormSetupAndMoveTo(target_pos, 0, 0, false);

								while (.HasPath) {
									.FormKeepMoving(1000);
									if (sh.IsDead)
										break;
									if (.DistTo(sh) < 600)
										break;
									if (sh.DistTo(target_pos) > 350) {//avoid moving the army every time or it risks messing up with obstacles nearby
										target_pos = sh.pos;
										.FormSetupAndMoveTo(target_pos, 0, 0, false);
									}
								}
							}
							.AddCommand(true, "boardshipcommon", sh);
						}
						.army.SetCommand("boardship", sh);
					}
	}

Sleep(30);//prevent possible loops with other commands