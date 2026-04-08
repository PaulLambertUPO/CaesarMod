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
						Settlement set_this, set_followed_unit, invalid;
						Building hall;
						Obj teleport;
						point enter_point;

						while (followed_unit.IsAlive) {
							if (.IsEnemy(followed_unit))
								break;
							if (!.CanSee(followed_unit))
								break;

							teleport = FindTeleport(.player, .posRH, followed_unit.posRH);
							if (teleport.IsValid) {
								if (.AI) {
									.AddCommand(true, "follow", followed_unit);
									.AddCommand(true, "teleport", teleport);
									break;
								}
								if (.posRH.Dist(teleport.pos) <= 1000) {
									.AddCommand(true, "follow", followed_unit);
									.AddCommand(true, "teleport", teleport);
									break;
								}
							}

							if (followed_unit.InHolder) {
								set_followed_unit = followed_unit.GetHolderSett();
								if (set_followed_unit.IsValid)
									if (set_this == set_followed_unit)
										Sleep(3000);
									else {
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
											while (true) {
												if (followed_unit.IsDead)
													break;
												if (.IsEnemy(followed_unit))
													break;
												if (!.CanSee(followed_unit))
													break;
												if (followed_unit.InHolder) {
													.SetEntering(true);
													if (.GotoEnter(enter_point, 0, 1000, false, -1)) {
														set_followed_unit.AddUnit(this);
														set_this = set_followed_unit;
														break;
													}
												}
												else
													break;
											}
										}
									}
								else if (!.GetShip().IsValid) {
									Ship s;
									s = followed_unit.GetShip();
									if (s.IsValid)
										if (.posRH.Dist(s.pos) <= 1200)
											.AddCommand(true, "boardship", s);
									break;
								}
							}
							else {
								set_this = invalid;
								.SetEntering(false);
								if (.Goto(followed_unit, 70, 1000, false, -1))
									Sleep(1500);
							}
						}
					}
		}

Sleep(15);//prevent possible loops with other commands