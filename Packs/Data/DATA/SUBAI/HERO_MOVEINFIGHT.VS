// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if (.AsHero().HasFinalPartyOrientationRequest()) {
	.AddCommand(true, "move", pt);
	return;
}

while (!.Goto(pt, 0, 2000, true, 0));
Sleep(7000);
