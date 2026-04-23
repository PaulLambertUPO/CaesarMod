//void, Obj This, bool bCanceled

if (bCanceled) {
	Hero this;

	this = This.AsHero();

	if (.IsValid)
		if (.IsAlive) {
			Ship sh;

			sh = .GetShipToBoard();

			if (sh.IsAlive)
				sh.NotifyBoardUnitCancel(this);

			.CancelArmyBoard();
		}
}