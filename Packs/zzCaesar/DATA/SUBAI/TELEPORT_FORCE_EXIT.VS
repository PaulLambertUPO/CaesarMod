//void, Obj This

Sleep(200 + rand(301));

if (This.AsTeleport().IsValid) {
	Settlement this;
	ObjList trapped_units;
	Unit u;
	int i;

	this = This.AsTeleport().settlement;

	while (true) {
		trapped_units = .Units;

		for (i = trapped_units.count - 1; i >= 0; i -= 1) {
			u = trapped_units[i].AsUnit();
			if (u.IsAlive)
				if (u.command == "idle")
					if (!u.hero.IsValid)
						if (u.GetHolderSett() == this)
							u.SetCommand("teleport", This);
		}

		Sleep(1000);
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);