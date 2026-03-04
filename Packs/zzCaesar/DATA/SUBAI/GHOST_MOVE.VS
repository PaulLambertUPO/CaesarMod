//void, Obj This, point pt

Ghost this;

this = This.AsGhost();

if (.IsValid)
	if (.IsAlive) {
		if (.GetAnim() == 17)//spawn
			Sleep(.TimeToAnimFinish);

		while (!.Goto(pt, 0, 2000, false, 0))
			;
	}

Sleep(15);//prevent possible loops with other commands