//void, Obj This, Obj bld

Unit this;

this = This.AsUnit();

if (.IsValid)
	.SetParryMode(false);

if (bld.IsValid) {
	Building building;
	point pt;

	if (.hero.IsValid)
		.DetachFrom(.hero);

	.SetEntering(true);
	building = bld.AsBuilding();
	pt = building.GetEnterPoint(this);

	while (bld.IsValid) {
		if (bld.IsAlive) {
			if (.GotoEnter(pt, 0, 1000, false, 0))
				break;
		}
		else
			break;
	}

	if (bld.IsValid)
		if (bld.IsAlive) {
			building.settlement.AddUnit(this);
			return;
		}

	.AddCommand(false, "move", pt + Point(0, 1));//prevent moving all units to the same place
}