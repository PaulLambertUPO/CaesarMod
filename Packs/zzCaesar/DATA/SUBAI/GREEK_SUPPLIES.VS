//void, int player

ObjList units;
Unit u;
int i, j, interval;

interval = GetConst("DropFoodByOneIvl") * 2;

while (1) {
	Sleep(interval);
	for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
		units = GetPlayerUnits(i);
		units.ClearDead();
		for (j = 0; j < units.count; j += 1) {
			u = units[j].AsUnit();
			if (u.IsValid)
				if (u.player == player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
					if (u.food > 0)
						if (u.food != u.maxfood)//food might be over the maximum in some cases (adventures)
							u.SetFood(u.food + 1);
		}
	}
}