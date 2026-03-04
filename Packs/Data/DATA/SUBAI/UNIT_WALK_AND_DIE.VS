//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		.Goto(pt, 0, 3000, false, -1);
		.Damage(.health);
	}