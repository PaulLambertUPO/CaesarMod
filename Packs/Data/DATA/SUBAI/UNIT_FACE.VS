//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			.Face(pt);
			Sleep(1000 + rand(1001));
		}

Sleep(30);//prevent possible loops with other commands