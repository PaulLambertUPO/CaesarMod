//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Hero h;

		h = other.AsHero();

		if (h.IsValid) {
			Settlement set_h;
			Building hall;
			Obj teleport;
			point enter_point;
			int plr;

			plr = .player;

			if (IsAIPlayer(plr))
				.SetParryMode(false);

			while (h.IsAlive) {
				if (.HasFreedom)
					break;
				if (h == .hero)
					break;
				if (h.IsHeroArmyFull)
					break;
				if (.IsEnemy(h))
					break;
				if (h.IsEnemy(this))
					break;

				if (.SameHolderAs(h))
					if (Dist(.posRH, h.posRH) < 1500)
						if (.AttachTo(h))
							break;

				if (h.InShip)
					break;

				teleport = FindTeleport(plr, .posRH, h.posRH);
				if (teleport.IsValid) {
					if (.AI) {
						.AddCommand(true, "attach", h);
						.AddCommand(true, "teleport", teleport);
						break;
					}
					if (Dist(.posRH, teleport.pos) <= 1000) {
						.AddCommand(true, "attach", h);
						.AddCommand(true, "teleport", teleport);
						break;
					}
				}

				if (h.InHolder) {
					set_h = h.GetHolderSett();
					if (set_h.IsValid) {
						hall = set_h.GetCentralBuilding();
						if (hall.IsValid) {
							if (hall.IsHeirOf("BaseRuins")) {
								Sleep(1500);
								continue;
							}
							enter_point = hall.GetEnterPoint(this);
							.SetEntering(true);
							while (h.IsAlive) {//full army is not checked here to avoid having only some units outside the building
								if (.HasFreedom)
									break;
								if (h == .hero)
									break;
								if (.IsEnemy(h))
									break;
								if (h.IsEnemy(this))
									break;
								if (h.InHolder) {
									if (.GotoEnter(enter_point, 0, 1000, false, 2500)) {
										set_h.AddUnit(this);
										break;
									}
								}
								else
									break;
							}
							.SetEntering(false);
						}
					}
					else
						break;
				}
				else if (.Goto(h.posRH, 200, 1500, false, 5000))
					Sleep(1000);
			}
		}
	}

Sleep(15);//prevent possible loops with other commands