//void, Obj This

Settlement this, supplied;
Building hall;
Wagon wagon;
int min_resource, min_pop, gold, food;

this = This.AsBuilding().settlement;
hall = .GetCentralBuilding();
min_resource = GetConst("MinResQtyToTransport");
min_pop = GetConst("MinPopulation");

Sleep(rand(1000) + 500);

while (1) {
	Sleep(3000);

	if (.supplied == this)
		.StopSupply();

	supplied = .supplied;

	if (supplied.IsValid)
		if (!.IsEnemy(supplied.player)) {
			gold = .gold;
			food = .food;
			if (.population < min_pop || hall.IsBroken()) {//keep the minimum amount of resorces for the repopulate/repair command
				int gold_cost, food_cost;
				if (GetCmdCost("repair village", gold_cost, food_cost)) {
					gold -= gold_cost;
					food -= food_cost;
				}
			}
			if (gold >= min_resource)
				if (!supplied.IsTTent()) {
					wagon = .CreateMuleGold(MIN(1000, gold));
					wagon.SetCommand("unload", supplied.GetCentralBuilding());
					wagon.AddCommand(false, "unload", hall);//come back if the destination becomes invalid during the travel
				}
			if (food >= min_resource) {
				wagon = .CreateMuleFood(MIN(1000, food));
				wagon.SetCommand("unload", supplied.GetCentralBuilding());
				wagon.AddCommand(false, "unload", hall);//come back if the destination becomes invalid during the travel
			}
		}
}