//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid) {
	if (.InShip) {
		Ship s;

		s = .GetShip();
		
		if (s.IsValid)
			if (s.IsAlive) {
				if (s.player != .player)
					if (!DiplGetShareControl(s.player, .player)) {
						s.SetCommand("unboardall", s.pos);
						return;
					}
			}
			else
				return;
		else
			return;
	}
	while (!.Goto(pt, 0, 2000, false, 0))
		;
}