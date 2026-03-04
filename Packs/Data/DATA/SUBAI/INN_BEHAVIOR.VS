//void, Obj This

Sleep(500 + rand(501));//give other scripts a chance to make the inn known to avoid displaying the discovery notification

while (1) {
	while (GetInnState(This) != 3)
		Sleep(5000);

	WaitNonEmptyQuery(Intersect(ObjsInSight(This, "Unit"), PartyQuery), -1);

	UserNotification("inn spotted", Translatef("Inn found: %s1, %s2", This.name, MapName), This.pos, Party[0].player);

	SetInnState(This, 1);
}