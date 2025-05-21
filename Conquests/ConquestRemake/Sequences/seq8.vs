ObjList neutral_buildings, nearby_units;
Building b;
int i;

neutral_buildings = Union(ClassPlayerObjs(cBaseVillage, 15), ClassPlayerObjs(cBaseShipyard, 15)).GetObjList();

while (neutral_buildings.count > 0) {
	for (i = neutral_buildings.count - 1; i >= 0; i -= 1) {
		b = neutral_buildings[i].AsBuilding();
		if (b.IsValid) {
			nearby_units = ObjsInRange(b, cMilitary, 850).GetObjList();
			nearby_units.ClearDead();
			if (nearby_units.count > 0) {
				int j, p;
				p = nearby_units[rand(nearby_units.count)].player;
				while (j < 10 && (p == 6 || p == 9 || p >= 14)) {
					p = nearby_units[rand(nearby_units.count)].player;
					j += 1;
				}
				if (p != 6)
					if (p != 9)
						if (p < 14) {//enemy support players must be changed to their real counterparts
							if (p == 10)
								p = 2;
							else if (p == 11)
								p = 3;
							else if (p == 12)
								p = 4;
							else if (p == 13)
								p = 5;
							b.SetPlayer(p);
							neutral_buildings.Remove(b);
						}
			}
		}
		else
			neutral_buildings.Remove(b);
	}
	Sleep(1500);
}