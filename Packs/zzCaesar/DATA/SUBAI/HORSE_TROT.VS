//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		.SetSpeedFactor(80);
		.SetWalkAnim(2);

		while (!.Goto(pt, 0, 2500, false, 0))
			;
	}

Sleep(15);//prevent possible loops with other commands