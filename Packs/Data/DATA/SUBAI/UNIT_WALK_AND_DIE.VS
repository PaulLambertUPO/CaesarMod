//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		if (!.Goto(pt, 0, 1500, false, -1))//if blocked by something that moves, try again
			.Goto(pt, 0, 1500, false, -1);
		.Damage(.health);
	}

Sleep(30);//prevent possible loops with other commands