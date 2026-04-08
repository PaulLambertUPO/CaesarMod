//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		ObjList pack;
		Obj o, pack_leader;
		int i;

		.SetSpeedFactor(100);

		Sleep(25 + rand(26));//random delay to manage the leader check of the first iteration for multiple lions (lower value for alpha male lions to increase their lead chance)
		if (.IsHeirOf("LionF"))
			Sleep(25);

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(2500);
			else {
				Sleep(500);

				pack = ObjsInRange(this, "LionM", .sight * 3 / 2).GetObjList();
				for (i = pack.count - 1; i >= 0; i -= 1) {
					o = pack[i];
					if (o.IsAlive) {
						if (o.command == "engage") {
							.AddCommand(true, "engage");
							Sleep(15);//prevent possible loops with other commands
							return;
						}
						if (o.command == "lead") {
							pack_leader = o;
							break;
						}
					}
				}

				if (!pack_leader.IsValid) {
					pack = ObjsInRange(this, "LionF", .sight * 3 / 2).GetObjList();
					for (i = pack.count - 1; i >= 0; i -= 1) {
						o = pack[i];
						if (o.IsAlive) {
							if (o.command == "engage") {
								.AddCommand(true, "engage");
								Sleep(15);//prevent possible loops with other commands
								return;
							}
							if (o.command == "lead") {
								pack_leader = o;
								break;
							}
						}
					}
				}

				if (!pack_leader.IsValid) {
					.AddCommand(true, "lead");
					break;
				}

				while (pack_leader.IsAlive) {
					if (pack_leader.command == "engage") {
						.AddCommand(true, "engage");
						Sleep(15);//prevent possible loops with other commands
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

Sleep(15);//prevent possible loops with other commands