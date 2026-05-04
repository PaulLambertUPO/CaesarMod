//void, Obj This, Obj other

if (!other.AsCatapult().IsValid) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive) {
			Building bld;

			if (.AI)
				.SetParryMode(false);

			bld = other.AsBuilding();

			if (bld.IsValid)
				if (other.AsTeleport().IsValid) {
					Settlement set;

					set = bld.settlement;

					if (!set.Units.Contains(this)) {
						point pt;

						pt = bld.GetEnterPoint(this);

						.SetEntering(true);

						while (!.GotoEnter(pt, 0, 1000, false, 2500))
							;

						set.AddUnit(this);
					}
				}
				else if (!bld.IsHeirOf("BaseRuins"))
					if (bld.IsCentralBuliding)
						if (!.IsEnemy(bld))
							if (DiplGetShareView(bld.player, .player)) {
								Settlement set;

								set = bld.settlement;

								if (set.max_units > 0)
									if (!set.Units.Contains(this)) {
										point pt;

										pt = bld.GetEnterPoint(this);

										.SetEntering(true);

										while (!.GotoEnter(pt, 0, 1000, false, 2500))
											if (.IsEnemy(bld))
												break;

										if (!.IsEnemy(bld))
											if (DiplGetShareView(bld.player, .player))
												set.AddUnit(this);
									}
						}
		}
}

Sleep(30);//prevent possible loops with other commands