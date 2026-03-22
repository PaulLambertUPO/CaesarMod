//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		.SetSpeedFactor(150);
		.SetWalkAnim(1);

		while (!.Goto(pt, 0, 2500, false, 0))
			;
	}