//void, Obj This

Sleep(rand(201) + 200);

if (This.AsBuilding().IsValid) {
	Settlement this;

	this = This.AsBuilding().settlement;

	if (.IsValid) {
		ObjList ol;
		Unit u;
		int i, food_to_give;

		while (1) {
			ol = Union(ObjsInSight(This, "Military"), ObjsInSight(This, "Peaceful")).GetObjList();//exclude animals
			ol.ClearDead();
			for (i = 0; i < ol.count; i += 1)
				if (.food > 0) {
					u = ol[i].AsUnit();
					if (u.IsValid)
						if (u.food < u.maxfood)
							if (DiplGetShareSupport(.player, u.player)) {
								food_to_give = MIN(.food, u.maxfood - u.food);
								u.SetFood(u.food + food_to_give);
								.SetFood(.food - food_to_give);
							}
				}
			Sleep(2000);
		}
	}
}

while (1)
	Sleep(3600000);