//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		.SetSpeedFactor(80);
		.SetWalkAnim(2);

		while (!.Goto(pt, 0, 2000, false, 1500))
			;
	}

Sleep(30);//prevent possible loops with other commands