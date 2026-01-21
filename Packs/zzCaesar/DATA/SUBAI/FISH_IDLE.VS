//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid) {
	point dir, pt;
	rect rc;
	int radius;

	if (!.GetFlags(UNITFLAG_NOAI))//this check avoids a crash if the script is restarted because SetNoAIFlag cannot be used after SetNoselectFlag
		.SetNoAIFlag(true);
	.SetNoselectFlag(true);
	.SetMinimapFlag(true);

	dir = .GetDir();
	rc = GetMapRect();
	radius = .radius + 5;

	Sleep(1000);//this prevents a game freeze caused by the script termination of the Goto loop below

	while (1) {
		dir.SetLen(300 + rand(351));
		dir.Rot(rand(360));
		pt = dir + .pos;
		if (!pt.InRect(rc))
			.Idle(50);
		else if (!IsPointInWater(pt))
			.Idle(50);
		else
			while (!.Goto(pt, radius, 10000, true, 0))
				if (!.HasPath())
					break;
	}
}