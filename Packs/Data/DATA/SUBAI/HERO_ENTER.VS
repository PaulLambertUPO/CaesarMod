//void, Obj This, Obj other

if (!other.AsCatapult().IsValid) {
	Hero this;

	this = This.AsHero();

	if (.IsValid)
		if (.IsAlive)
			if (other.AsTeleport().IsValid)
				.AddCommand(true, "teleport", other);
			else {
				Building bld;

				bld = other.AsBuilding();

				if (bld.IsValid)
					if (bld.IsHeirOf("BaseRuins")) {
						Settlement set;

						set = bld.settlement;

						if (set.Units.Contains(this))
							.army.SetCommand("idle");
						else {
							point pt;

							pt = bld.GetEnterPoint(this);

							.FormSetupAndMoveTo(pt, 0, 0, false);

							while (.HasPath) {
								if (.FormPathLeft < .FormRadius + 150)
									break;
								if (.DistTo(bld) < .FormRadius)
									break;
								.FormKeepMoving(1500);
							}

							.army.SetCommand("idle");
							
							.SetEntering(true);

							while (!.GotoEnter(pt, 0, 1000, false, 2500))
								;

							if (set.AddUnit(this))
								.AddCommand(true, "sleep");
						}
					}
					else if (bld.IsCentralBuliding)
						if (!.IsEnemy(bld))
							if (DiplGetShareView(bld.player, .player)) {
								Settlement set;

								set = bld.settlement;

								if (set.max_units > 0)
									if (set.Units.Contains(this))
										.army.SetCommand("enter", bld);
									else {
										point pt;

										pt = bld.GetEnterPoint(this);

										.FormSetupAndMoveTo(pt, 0, 0, false);

										while (.HasPath) {
											if (.FormPathLeft < .FormRadius + 150)
												break;
											if (.DistTo(bld) < .FormRadius)
												break;
											.FormKeepMoving(1500);
										}

										if (!.IsEnemy(bld))
											if (DiplGetShareView(bld.player, .player)) {
												.army.SetCommand("enter", bld);

												.SetEntering(true);

												while (!.GotoEnter(pt, 0, 1000, false, 2500))
													;

												if (!.IsEnemy(bld))
													if (DiplGetShareView(bld.player, .player))
														set.AddUnit(this);
											}
									}
							}
			}
}

Sleep(15);//prevent possible loops with other commands