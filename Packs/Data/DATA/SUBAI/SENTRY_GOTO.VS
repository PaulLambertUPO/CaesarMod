//void, Obj me, point pt

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive)
		while (!.Goto(pt, 0, 2000, false, 0))
			;

Sleep(15);//prevent possible loops with other commands