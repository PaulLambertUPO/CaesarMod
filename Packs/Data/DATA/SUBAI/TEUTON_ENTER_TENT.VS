//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building bld;

		bld = other.AsBuilding();

		if (bld.IsValid)
			if (!.IsEnemy(bld)) {
				Settlement set;

				set = bld.settlement;

				if (!set.Units.Contains(this)) {
					point pt;

					pt = bld.GetEnterPoint(this);

					.SetEntering(true);

					while (!.GotoEnter(pt, 0, 1000, false, 5000))
						;

					set.ForceAddUnit(this);
				}
			}
	}