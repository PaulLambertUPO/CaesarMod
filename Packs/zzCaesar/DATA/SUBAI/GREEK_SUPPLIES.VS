//void, int player

ObjList ol;
Unit u;
int i, j, interval;

interval = GetConst("DropFoodByOneIvl") * 2;

while (true) {
	for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
		ol = GetPlayerUnits(i);
		for (j = ol.count - 1; j >= 0; j -= 1) {
			u = ol[j].AsUnit();
			if (u.IsAlive)
				if (u.player == player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
					if (u.food > 0)
						if (u.food != u.maxfood)//food might be over the maximum in some cases (adventures)
							u.SetFood(u.food + 1);
		}
	}
	Sleep(interval);
}