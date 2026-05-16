//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building bld;

		.SetParryMode(false);

		bld = other.AsBuilding();

		if (bld.IsValid)
			if (!.IsEnemy(bld)) {
				Settlement set;

				set = bld.settlement;

				if (!set.Units.Contains(this)) {
					point pt;

					pt = bld.GetEnterPoint(this);

					.SetEntering(true);

					while (!.GotoEnter(pt, 0, 1000, false, 2500))
						if (.IsEnemy(bld))
							break;

					if (!.IsEnemy(bld))
						set.ForceAddUnit(this);
				}
			}
	}

Sleep(30);//prevent possible loops with other commands