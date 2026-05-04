//void, Obj This, Obj other

Wagon this;

this = This.AsWagon();

if (.IsValid)
	if (.IsAlive)
		if (other != this) {
			Unit followed_unit;

			followed_unit = other.AsUnit();

			if (followed_unit.IsValid)
				if (!followed_unit.IsSentry)
					if (!followed_unit.IsWaterUnit) {
						Settlement set_followed_unit;
						Building hall;
						Obj teleport;
						point enter_point;
						int plr;

						plr = .player;

						while (followed_unit.IsAlive) {
							if (.IsEnemy(followed_unit))
								break;
							if (!.CanSee(followed_unit))
								break;

							teleport = FindTeleport(plr, .posRH, followed_unit.posRH);
							if (teleport.IsValid) {
								if (.AI) {
									.AddCommand(true, "follow", followed_unit);
									.AddCommand(true, "teleport", teleport);
									break;
								}
								if (Dist(.posRH, teleport.pos) <= 1000) {
									.AddCommand(true, "follow", followed_unit);
									.AddCommand(true, "teleport", teleport);
									break;
								}
							}

							if (followed_unit.InHolder)
								if (.SameHolderAs(followed_unit))
									Sleep(3000);
								else {
									set_followed_unit = followed_unit.GetHolderSett();
									if (set_followed_unit.IsValid) {
										hall = set_followed_unit.GetCentralBuilding();
										if (hall.IsValid) {
											if (hall.IsHeirOf("BaseRuins")) {
												Sleep(1500);
												continue;
											}
											if (hall.AsCatapult().IsValid) {
												Sleep(1500);
												continue;
											}
											enter_point = hall.GetEnterPoint(this);
											.SetEntering(true);
											while (followed_unit.IsAlive) {
												if (.IsEnemy(followed_unit))
													break;
												if (!.CanSee(followed_unit))
													break;
												if (followed_unit.InHolder) {
													if (.GotoEnter(enter_point, 0, 1000, false, -1)) {
														set_followed_unit.AddUnit(this);
														break;
													}
												}
												else
													break;
											}
											.SetEntering(false);
										}
									}
									else if (.InShip)
										break;
									else {
										Ship s;
										s = followed_unit.GetShip();
										if (s.IsValid)
											if (Dist(.posRH, s.pos) <= 1200)
												.AddCommand(true, "boardship", s);
										break;
									}
								}
							else if (.Goto(followed_unit, 70, 1000, false, -1))
								Sleep(1500);
						}
					}
		}

Sleep(30);//prevent possible loops with other commands