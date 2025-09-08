//void, Obj This, Obj target

if (target.IsValid) {
	Building this;

	this = This.AsBuilding();

	if (.IsValid) {
		if (.settlement.IsOutpost)
			if (.settlement.IsIndependent)
				return;

		.SetUITarget(target);

		Sleep(100);
	}
}