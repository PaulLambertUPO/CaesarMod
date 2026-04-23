//void, Obj This, bool bCanceled

if (bCanceled) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive) {
			Ship sh;

			sh = .GetShipToBoard();

			if (sh.IsAlive)
				sh.NotifyBoardUnitCancel(this);
		}
}