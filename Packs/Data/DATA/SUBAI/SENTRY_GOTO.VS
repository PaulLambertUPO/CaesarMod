//void, Obj me, point pt

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive)
		while (!.Goto(pt, 0, 2000, false, 0))
			;