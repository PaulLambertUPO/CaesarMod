//void, Obj This 

Building this;
Settlement set;

this = This.AsBuilding();
set = .settlement;

.Progress(.cmddelay);

set.SetPopulation(MAX(set.population, set.max_population));