//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid) {
	ObjList pack;
	Unit u, pack_leader;
	int i;

	Sleep(rand(15));//random delay to manage the leader check of the first iteration for multiple lions (lower for alpha male lions to increase their lead chance)
	if (.IsHeirOf("LionF"))
		Sleep(15);

	while (!.Stop(1000))
		;

	.Idle(500);

	while (1) {
		Sleep(500);

		pack = ObjsInRange(this, "LionM", .sight * 3 / 2).GetObjList();
		for (i = 0; i < pack.count; i += 1) {
			u = pack[i].AsUnit();
			if (u.IsValid) {
				if (u.command == "engage") {
					.AddCommand(true, "engage");
					return;
				}
				if (u.command == "lead") {
					pack_leader = u;
					break;
				}
			}
		}
		if (!pack_leader.IsValid) {
			pack = ObjsInRange(this, "LionF", .sight * 3 / 2).GetObjList();
			for (i = 0; i < pack.count; i += 1) {
				u = pack[i].AsUnit();
				if (u.IsValid) {
					if (u.command == "engage") {
						.AddCommand(true, "engage");
						return;
					}
					if (u.command == "lead") {
						pack_leader = u;
						break;
					}
				}
			}
		}
		if (!pack_leader.IsValid) {
			.AddCommand(true, "lead");
			return;
		}
		while (pack_leader.IsAlive) {
			if (pack_leader.command == "engage") {
				.AddCommand(true, "engage");
				return;
			}
			if (pack_leader.command == "lead")
				if (.DistTo(pack_leader) > 50)
					.Goto(pack_leader.pos + Point(rand(51) - 25, rand(51) - 25), 0, 1500, false, 0);
				else {
					.Idle(500);
					continue;
				}
			else
				break;
			Sleep(500);
		}
		pack_leader.Clear();
	}
}