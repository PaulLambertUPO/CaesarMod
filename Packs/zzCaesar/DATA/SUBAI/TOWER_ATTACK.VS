//void, Obj This, Obj target

if (target.IsValid) {
	Tower this;

	this = This.AsTower();

	if (.IsValid) {
		if (.settlement.IsOutpost)
			if (.settlement.IsIndependent)
				return;

		.SetUITarget(target);

		Sleep(100);
	}
}