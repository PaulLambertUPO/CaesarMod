//void, Obj This, point pt

Ship this;

this = This.AsShip();

if (.IsValid)
	if (.IsAlive) {
		while (!.Goto(pt, 0, 2000, true, -1))//use -1 with the inner check because there is something strange with ships
			if (.TimeWithoutWalking > 0)
				break;

		.UnboardAllUnits();//this function does not cause a crash if someone dies during the travel (not like UnboardUnits)
	}

Sleep(15);//prevent possible loops with other commands