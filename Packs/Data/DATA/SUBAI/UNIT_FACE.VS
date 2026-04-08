//void, Obj this, point pt

if (.AsUnit().IsValid)
	if (.IsAlive) {
		.Face(pt);
		Sleep(1000 + rand(1001));
	}

Sleep(15);//prevent possible loops with other commands