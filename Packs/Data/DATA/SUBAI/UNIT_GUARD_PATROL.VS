// void, Obj This, point pt

Unit this;
Unit u;
this = This.AsUnit();

if(!.InHolder)
	.AddCommand(false, "guardpatrol", .pos);
while(1) {
	u = .BestTargetInSquadSight();
	if(u.IsAlive() && .IsValidTarget(u))
	{
		if(u.IsMilitary() || u.IsHeirOf("BaseMage"))
		{
			.AddCommand(true, "guardpatrol", pt);
			.AddCommand(true, "guardengage");
			return;
		}
	}
	if(.Goto (pt, 0, 2000, true, -1)) {
		Sleep(500);  // Else when Goto returns immediately there's an infinite loop of patrol commands (the software dies)
		break;
	}
	if(.TimeWithoutWalking() > 0) {
		Sleep(500);
		break;
	}
}
