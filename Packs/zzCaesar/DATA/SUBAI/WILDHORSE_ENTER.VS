//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building bld;

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
			else if (bld.IsHeirOf("IVillage"))
				if (!.IsEnemy(bld)) {
					point pt;

					pt = bld.GetEnterPoint(this);

					.SetEntering(true);

					while (!.GotoEnter(pt, 0, 1000, false, 2500))
						if (.IsEnemy(bld))
							break;

					if (!.IsEnemy(bld)) {
						Settlement set;

						set = bld.settlement;

						EnvWriteInt(set, "EEE_IVillageNumberHorses", EnvReadInt(set, "EEE_IVillageNumberHorses") + 1);
						.Erase();
					}
				}
	}

Sleep(30);//prevent possible loops with other commands