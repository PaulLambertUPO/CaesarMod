//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		while (!.Goto(pt, 0, 2000, false, 0))
			;

Sleep(15);//prevent possible loops with other commands