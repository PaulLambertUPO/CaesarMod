//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InShip) {
			Ship sh;

			sh = other.AsShip();

			if (sh.IsValid) {
				int plr, max_units, ai_time_stuck;

				plr = .player;
				max_units = sh.UnitsMax;

				if (IsAIPlayer(plr))
					.SetParryMode(false);

				while (sh.IsAlive) {
					if (.GotoEnter(sh.pos, 120, 2000, false, -1))
						Sleep(250);
					if (sh.IsDead)
						break;
					if (!DiplGetShareControl(sh.player, plr))
						break;
					if (sh.UnitsCount >= max_units)
						break;
					if (sh.NumUnitsToBoard <= 0)
						break;
					if (sh.BoardUnit(this))
						break;
					if (.AI) {
						if (.DistTo(sh.pos) < 500)
							ai_time_stuck += 1;
						if (ai_time_stuck >= 10) {
							sh.NotifyBoardUnitCancel(this);//the function used in the onfinish script does not seem to be triggered by the AI and the ship gets stuck
							break;
						}
					}
				}
			}
		}

Sleep(15);//prevent possible loops with other commands