//void, Obj this, point pt

if (.AsUnit().IsValid)
	if (.IsAlive) {
		.AddCommand(false, "patrol", .posRH);
		.AddCommand(true, "advance_aggressive", pt);
	}

Sleep(30);//prevent possible loops with other commands