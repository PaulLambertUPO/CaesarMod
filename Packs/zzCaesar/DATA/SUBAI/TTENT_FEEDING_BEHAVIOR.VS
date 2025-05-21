//void, Obj This

if (This.AsBuilding().IsValid) {
	Settlement this;

	this = This.AsBuilding().settlement;

	if (.IsValid) {
		ObjList ol;
		Unit u;
		int i, interval;

		interval = GetConst("DropFoodByOneIvl");

		while (1) {
			Sleep(interval);

			ol = .Units;
			ol.ClearDead();

			for (i = 0; i < ol.count; i += 1) {
				u = ol[i].AsUnit();
				if (u.IsValid)
					u.SetFood(20);
			}
		}
	}
}

while (1)
	Sleep(3600000);