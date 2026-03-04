//void, Obj b

Building this;

this = b.AsBuilding();

.Progress();

{
	Settlement set;
	int min_pop;

	set = .settlement;
	min_pop = GetConst("MinPopulation") + 1;

	if (cmdcost_gold > 0)
		set.SetGold(set.gold - cmdcost_gold);
	if (cmdcost_food > 0)
		set.SetFood(set.food - cmdcost_food);
	if (cmdcost_pop > 0)
		set.AddToPopulation(-cmdcost_pop);

	if (set.population < min_pop)
		set.SetPopulation(min_pop);

	if (.IsBroken)
		.RRepair();
}