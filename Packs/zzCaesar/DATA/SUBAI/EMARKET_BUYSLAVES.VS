//void, Obj this 

Settlement set;

set = .AsBuilding().settlement;

.Progress();

if (set.population < set.max_population)
	set.SetPopulation(set.max_population);