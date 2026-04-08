//void, Obj This

Sleep(250 + rand(251));

{
	Settlement this, supp;
	Building hall;
	Wagon mule;
	ObjList ol;
	Unit u;
	int i, f, min_resource, min_pop, repopulate_cost_gold, repopulate_cost_food, gold_to_give, food_to_give;

	this = This.AsBuilding().settlement;
	hall = .GetCentralBuilding();
	min_resource = GetConst("MinResQtyToTransport");
	min_pop = GetConst("MinPopulation");

	GetCmdCost("repair village", repopulate_cost_gold, repopulate_cost_food);

	while (true) {
		if (.population < min_pop) {//keep the minimum amount of resorces for the repopulate/repair command
			gold_to_give = .gold - repopulate_cost_gold;
			food_to_give = .food - repopulate_cost_food;
		}
		else if (hall.IsBroken) {//keep the minimum amount of resorces for the repopulate/repair command
			gold_to_give = .gold - repopulate_cost_gold;
			food_to_give = .food - repopulate_cost_food;
		}
		else {
			gold_to_give = .gold;
			food_to_give = .food;
		}

		if (.supplied == this)
			.StopSupply();

		supp = .supplied;

		if (supp.IsValid)
			if (!.IsEnemy(supp.player)) {
				if (gold_to_give >= min_resource)
					if (!supp.IsTTent) {
						mule = .CreateMuleGold(MIN(1000, gold_to_give));
						mule.SetCommand("unload", supp.GetCentralBuilding());
						mule.AddCommand(false, "unload", hall);//come back if the destination becomes invalid during the travel
					}
				if (food_to_give >= min_resource) {
					i = MIN(1000, food_to_give);
					mule = .CreateMuleFood(i);
					food_to_give -= i;
					mule.SetCommand("unload", supp.GetCentralBuilding());
					mule.AddCommand(false, "unload", hall);//come back if the destination becomes invalid during the travel
				}
			}

		if (food_to_give > 0) {
			ol = ObjsInSight(This, "Military,Peaceful").GetObjList();
			for (i = ol.count - 1; i >= 0; i -= 1) {
				u = ol[i].AsUnit();
				if (u.IsAlive) {
					f = CLAMP(u.maxfood - u.food, 0, food_to_give);
					if (f > 0)
						if (DiplGetShareSupport(u.player, .player)) {
							u.SetFood(u.food + f);
							.SetFood(.food - f);
							food_to_give -= f;
							if (food_to_give <= 0)
								break;
						}
				}
			}
		}

		Sleep(3000);
	}
}