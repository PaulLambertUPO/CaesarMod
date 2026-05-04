//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		.Stop(2000);
		while (.CmdCount <= 1)//avoid blocking pending commands forever
			Sleep(1000);
	}

Sleep(30);//prevent possible loops with other commands