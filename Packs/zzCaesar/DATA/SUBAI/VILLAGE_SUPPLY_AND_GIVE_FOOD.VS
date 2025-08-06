//void, Obj This

Settlement this, supplied;
Building hall;
Wagon mule;
ObjList ol;
Unit u;
int min_resource, min_pop, gold_to_give, food_to_give, i, f;

this = This.AsBuilding().settlement;
hall = .GetCentralBuilding();
min_resource = GetConst("MinResQtyToTransport");
min_pop = GetConst("MinPopulation");

Sleep(rand(251) + 250);

while (1) {
	Sleep(3000);

	gold_to_give = .gold;
	food_to_give = .food;
	if (.population < min_pop) {//keep the minimum amount of resorces for the repopulate/repair command
		int gold_cost, food_cost;
		if (GetCmdCost("repair village", gold_cost, food_cost)) {
			gold_to_give -= gold_cost;
			food_to_give -= food_cost;
		}
	}
	else if (hall.IsBroken) {//keep the minimum amount of resorces for the repopulate/repair command
		int gold_cost, food_cost;
		if (GetCmdCost("repair village", gold_cost, food_cost)) {
			gold_to_give -= gold_cost;
			food_to_give -= food_cost;
		}
	}

	if (.supplied == this)
		.StopSupply();

	supplied = .supplied;

	if (supplied.IsValid)
		if (!.IsEnemy(supplied.player)) {
			if (gold_to_give >= min_resource)
				if (!supplied.IsTTent) {
					mule = .CreateMuleGold(MIN(1000, gold_to_give));
					mule.SetCommand("unload", supplied.GetCentralBuilding());
					mule.AddCommand(false, "unload", hall);//come back if the destination becomes invalid during the travel
				}
			if (food_to_give >= min_resource) {
				i = MIN(1000, food_to_give);
				mule = .CreateMuleFood(i);
				food_to_give -= i;
				mule.SetCommand("unload", supplied.GetCentralBuilding());
				mule.AddCommand(false, "unload", hall);//come back if the destination becomes invalid during the travel
			}
		}

	if (food_to_give > 0) {
		ol = ObjsInSight(This, "Military,Peaceful").GetObjList();//exclude animals
		for (i = 0; i < ol.count; i += 1)
			if (food_to_give > 0) {
				u = ol[i].AsUnit();
				if (u.IsValid)
					if (u.IsAlive)
						if (u.food < u.maxfood)
							if (DiplGetShareSupport(.player, u.player)) {
								f = MIN(food_to_give, u.maxfood - u.food);
								u.SetFood(u.food + f);
								.SetFood(.food - f);
								food_to_give -= f;
							}
			}
	}
}