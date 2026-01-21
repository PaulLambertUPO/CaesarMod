//void, Obj b

Building this;

this = b.AsBuilding();

if (.IsValid) {
	.Progress();
	{
		Settlement set;

		set = .settlement;

		if (cmdcost_gold > 0)
			set.SetGold(set.gold - cmdcost_gold);
		if (cmdcost_food > 0)
			set.SetFood(set.food - cmdcost_food);
		if (cmdcost_pop > 0)
			set.AddToPopulation(-cmdcost_pop);
	}
	.RRepair();
}