//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		point pt, pt_walk, centre;
		int i;
		bool wait, walked = false;

		Sleep(500 + rand(501));

		{
			Settlement set;
			Building hall, bld;
			int j, dist, min = 10000000;

			j = MaxSetIdx;
			for (i = 0; i < j; i += 1) {
				set = IdxToSet(i);
				if (set.IsValid)
					if (set.IsVillage) {
						bld = set.GetCentralBuilding();
						if (bld.IsValid) {
							dist = .DistTo(bld.pos);
							if (dist < min) {
								min = dist;
								hall = bld;
							}
						}
					}
			}
			if (hall.IsValid)
				centre = hall.pos;
			else
				centre = .pos;//this should never happen because hens are spawned by villages
		}

		while (1) {
			if (walked) {
				walked = false;
				pt = .pos + RandomOffset(10);
				.Face(pt);
				.ForceIdle();
				.Idle(2000);
			}
			else if (rand(5) > 0) {
				pt = .pos + RandomOffset(15);
				.Face(pt);
				.ForceIdle();
				.Idle(2000);
			}
			else {
				if (.DistTo(centre) > 600)
					pt = GetVecByDir(.pos - centre, 500) + centre;
				else
					pt = .pos;
				for (i = 0; i < 5; i += 1) {
					pt_walk = pt + RandomOffset(200);
					if (IsPassable3x3(pt_walk))
						break;
				}
				wait = true;
				if (i < 5)
					while (!.Goto(pt_walk, 0, 2500, false, -1))
						wait = false;
				if (wait)
					Sleep(2500);
				walked = true;
			}
			Sleep(500);
		}
	}