//void, Obj This

Teleport this;

this = This.AsTeleport();

if (!.IsValid)
	while (1)
		Sleep(3600000);
else {
	ObjList lost_units;
	Unit u;
	int i;

	while (1) {
		Sleep(1000);

		lost_units = .settlement.Units;
		lost_units.ClearDead();

		for (i = 0; i < lost_units.count; i += 1) {
			u = lost_units[i].AsUnit();
			if (u.IsValid)
				if (u.IsAlive)
					if (!u.IsHeirOf("Hero"))
						if (!u.hero.IsValid)
							if (u.InHolder)
								if (u.GetHolderSett().GetCentralBuilding().IsHeirOf("Teleport"))
									if (u.command =="idle") {
										u.SetCommand("teleport", this);
										u.AddCommand(false, "idle");
									}
		}
	}
}