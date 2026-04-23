//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InShip) {
			Ship sh;

			sh = other.AsShip();

			if (sh.IsValid)
				if (sh.IsAlive)
					if (DiplGetShareControl(sh.player, .player))
						if (sh.UnitsCount < sh.UnitsMax) {
							sh.NotifyBoardUnit(this);
							.AddCommand(true, "boardshipcommon", sh);
						}
		}

Sleep(15);//prevent possible loops with other commands