//void, Obj This

Sleep(250 + rand(251));

{
	Settlement this, supp;
	Building hall;
	Wagon mule;
	ObjList ol;
	Unit u;
	Obj o_dummy;
	point pt_dummy;
	str cmd_train_peasant;
	int i, f, min_resource, min_pop, min_pop_cost, repopulate_cost_gold, repopulate_cost_food, gold_to_give, food_to_give;

	this = This.AsBuilding().settlement;
	hall = .GetCentralBuilding();
	min_resource = GetConst("MinResQtyToTransport");
	min_pop = GetConst("MinPopulation");
	min_pop_cost = min_pop + GetConst("PopGroup");

	GetCmdCost("repair village", repopulate_cost_gold, repopulate_cost_food);

	if (hall.race == ImperialRome)
		cmd_train_peasant = "trainpeasanth";
	else
		cmd_train_peasant = "trainpeasant" + hall.raceStrPrefLow;

	while (true) {
		if (.population < min_pop) {//keep the minimum amount of resorces for the repopulate/repair command
			gold_to_give = .gold - repopulate_cost_gold;
			food_to_give = .food - repopulate_cost_food;
			f = 0;
		}
		else if (hall.IsBroken) {//keep the minimum amount of resorces for the repopulate/repair command
			gold_to_give = .gold - repopulate_cost_gold;
			food_to_give = .food - repopulate_cost_food;
			f = 0;
		}
		else {
			gold_to_give = .gold;
			food_to_give = .food;
			f = 1;
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
				if (f == 1)
					if (EnvReadString(this, "AutoTrainPeasant") == "yes")
						if (.population >= .max_population)
							if (.population >= min_pop_cost)
								if (supp.max_population > 0)
									hall.ExecCmd(cmd_train_peasant, pt_dummy, o_dummy, false);
								else if (supp.max_units > 0)
									hall.ExecCmd(cmd_train_peasant, pt_dummy, o_dummy, false);
			}

		if (food_to_give > 0) {
			ol = .ObjectsAround("Military");
			ol.AddList(.ObjectsAround("Peaceful"));
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