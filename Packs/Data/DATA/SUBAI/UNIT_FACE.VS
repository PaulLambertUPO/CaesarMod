//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		.Face(pt);
		Sleep(1000 + rand(1001));
	}