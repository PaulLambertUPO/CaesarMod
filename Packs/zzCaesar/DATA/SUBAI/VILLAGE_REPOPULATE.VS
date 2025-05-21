//void, Obj b

Building this;

this = b.AsBuilding();

if (.IsValid) {
	int min_pop;

	.Progress();

	min_pop = GetConst("MinPopulation");
	if (.settlement.population < min_pop)
		.settlement.SetPopulation(min_pop);

	//if the repair command is executed when the village hall is broken, the cost is paid back because of a possible bug in the source code, so the health is set directly
	if (.IsBroken())
		.SetHealth(.maxhealth / 3);

	//using .RRepair() terminates the script, making it impossible to force the cost after the repairs (this is why health is set directly)
}