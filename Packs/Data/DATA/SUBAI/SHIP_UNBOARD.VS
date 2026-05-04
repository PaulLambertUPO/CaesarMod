//void, Obj This, ObjList ol, point pt

if (!IsPointInWater(pt)) {
	Ship this;

	this = This.AsShip();

	if (.IsValid)
		if (.IsAlive) {
			Obj o;
			int i, ship_player, o_player;

			ship_player = .player;

			for (i = ol.count - 1; i >= 0; i -= 1) {//exclude dead/invalid units and uncontrollable objects that might be selected via groups or quick selection icons
				o = ol[i];
				if (o.IsDead)
					ol.Remove(o);
				else {
					o_player = o.player;
					if (!DiplGetShareControl(ship_player, o_player))
						if (!DiplGetShareControl(o_player, ship_player))
							ol.Remove(o);
				}
			}

			if (ol.count > 0) {
				while (!.Goto(pt, 0, 1000, false, -1)) {//use -1 with the inner check because there is something strange with ships
					if (.TimeWithoutWalking > 0)
						break;
					for (i = ol.count - 1; i >= 0; i -= 1) {
						o = ol[i];
						if (o.IsDead)
							ol.Remove(o);
						else {
							o_player = o.player;
							if (!DiplGetShareControl(ship_player, o_player))
								if (!DiplGetShareControl(o_player, ship_player))
									ol.Remove(o);
						}
					}
					if (ol.count <= 0)
						break;
				}

				for (i = ol.count - 1; i >= 0; i -= 1) {
					o = ol[i];
					if (o.IsDead)
						ol.Remove(o);
					else {
						o_player = o.player;
						if (!DiplGetShareControl(ship_player, o_player))
							if (!DiplGetShareControl(o_player, ship_player))
								ol.Remove(o);
					}
				}

				if (ol.count > 0)
					.UnboardUnits(ol);//this function causes a crash if someone dies during the travel
			}
		}
}

Sleep(30);//prevent possible loops with other commands