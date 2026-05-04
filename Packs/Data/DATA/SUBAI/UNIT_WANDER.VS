//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		point where;

		while (.CmdCount <= 1) {//avoid blocking pending commands forever
			where.SetLen(50 + rand(.sight));
			where.Rot(rand(360));
			if (.Goto(pt + where, 0, 10000, false, -1))
				Sleep(2000 + rand(3001));
		}
	}

Sleep(30);//prevent possible loops with other commands