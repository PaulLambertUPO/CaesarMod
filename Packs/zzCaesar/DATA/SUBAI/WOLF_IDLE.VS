//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		ObjList pack;
		Obj o, pack_leader;
		int i;

		.SetSpeedFactor(100);

		Sleep(25 + rand(26));//random delay to manage the leader check of the first iteration for multiple wolves

		while (1)
			if (.InHolder)
				Sleep(2500);
			else {
				Sleep(500);

				pack = ObjsInRange(this, "Wolf", .sight * 3 / 2).GetObjList();
				for (i = pack.count - 1; i >= 0; i -= 1) {
					o = pack[i];
					if (o.IsAlive) {
						if (o.command == "engage") {
							.AddCommand(true, "engage");
							return;
						}
						if (o.command == "lead") {
							pack_leader = o;
							break;
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

					if (pack_leader.command != "lead")
						break;
					else if (.DistTo(pack_leader) > 50)
						.Goto(pack_leader.pos + RandomOffset(25), 0, 1500, false, 0);

					Sleep(500);
				}

				pack_leader.Clear();
			}
	}