//void, Obj this 

.Progress();

{
	Settlement set;

	set = .AsBuilding().settlement;

	if (set.population < set.max_population)
		set.SetPopulation(set.max_population);
}