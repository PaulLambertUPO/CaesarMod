//void, Obj This 

Building this;
Settlement set;

this = This.AsBuilding();
set = .settlement;

.Progress(.cmddelay);

if (set.population < set.max_population)
	set.SetPopulation(set.max_population);