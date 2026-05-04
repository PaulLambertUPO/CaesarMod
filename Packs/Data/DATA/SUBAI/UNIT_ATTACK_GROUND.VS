//void, Obj this, point pt

if (.AsUnit().IsValid)
	if (.IsAlive)
		.AddCommand(true, "advance", pt);

Sleep(30);//prevent possible loops with other commands