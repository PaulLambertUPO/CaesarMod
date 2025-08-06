//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid) {
	.SetSpeedFactor(80);
	.SetWalkAnim(2);

	while (!.Goto(pt, 0, 2000, true, 0))
		if (!.HasPath())
			break;
}