//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid) {
	point pt, dir;
	rect rc;

	.SetNoselectFlag(true);
	.SetMinimapFlag(true);

	dir = .GetDir();
	rc = GetMapRect();

	Sleep(1000);

	while (1) {//this loop prevents a game freeze caused by the exit of the Goto loop below
		dir.SetLen(.sight + rand(.sight / 2));
		dir.Rot(rand(360));
		pt = dir + .pos;
		if (!pt.InRect(rc))
			.Idle(50);
		else if (!IsPointInWater(pt))
			.Idle(50);
		else
			while (!.Goto(pt, 0, 10000, true, 0))
				if (!.HasPath())
					break;
	}
}