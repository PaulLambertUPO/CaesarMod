//void, Obj This

Ship this;

this = This.AsShip();

if (.IsValid)
	if (.IsAlive) {
		point pt;

		pt = .GetTransPt();

		while (!.Goto(pt, 0, 1000, false, -1))//use -1 with the inner check because there is something strange with ships
			if (.TimeWithoutWalking > 0)
				break;

		.ApplyAiTransport();
	}

Sleep(30);//prevent possible loops with other commands