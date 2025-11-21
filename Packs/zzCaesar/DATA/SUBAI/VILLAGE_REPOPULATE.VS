//void, Obj b

Building this;

this = b.AsBuilding();

if (.IsValid) {
	Settlement set;
	int min_pop;

	.Progress();

	set = .settlement;

	min_pop = GetConst("MinPopulation") + 1;

	if (set.population < min_pop)
		set.AddToPopulation(min_pop - set.population);//do not use SetPopulation in order to manage villages whose maximum population is below MinPopulation

	//if the repair command is executed when the village hall is broken, the cost is paid back because of a possible bug in the source code, so the health is set directly
	if (.IsBroken)
		.SetHealth(.maxhealth / 3);

	//using .RRepair() terminates the script, making it impossible to force the cost after the repairs (this is why health is set directly)
}