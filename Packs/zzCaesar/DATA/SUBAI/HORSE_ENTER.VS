//void, Obj This, Obj bld

Unit this;

this = This.AsUnit();

if (.IsValid) {
	Building b;

	b = bld.AsBuilding();

	if (b.IsValid)
		if (bld.IsHeirOf("IVillage"))
			if (!.IsEnemy(bld)) {
				Settlement set;

				set = b.settlement;

				if (set.IsValid) {
					.SetSpeedFactor(150);
					.SetWalkAnim(1);
					.SetEntering(true);

					if (!set.Units.Contains(this)) {
						point pt;

						pt = b.GetEnterPoint(this);

						while (!.GotoEnter(pt, 0, 1000, true, 5000))
							if (.IsEnemy(b))
								return;
					}

					EnvWriteInt(set, "EEE_IVillageNumberHorses", EnvReadInt(set, "EEE_IVillageNumberHorses") + 1);
					.Erase();
				}
			}
}