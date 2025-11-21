//void, Obj This, point pt

Unit this;

this = This.AsGhost();

if (.IsValid) {
	if (.GetAnim() == 17)//spawn
		Sleep(.TimeToAnimFinish);

	while (!.Goto(pt, 0, 2000, false, 0))
		if (!.HasPath())
			break;

	Sleep(15);//this reduces the risk of a move-idle loop
}