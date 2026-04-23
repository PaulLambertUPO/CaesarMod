//void, Obj This, point pt

Ship this;

this = This.AsShip();

if (.IsValid)
	if (.IsAlive) {
		.SetParryMode(false);

		while (!.Goto(pt, 0, 1000, false, -1))//use -1 with the inner check because there is something strange with ships
			if (.TimeWithoutWalking > 0)
				break;
	}

Sleep(15);//prevent possible loops with other commands