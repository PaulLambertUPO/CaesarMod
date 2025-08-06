//void, Obj This

Settlement this, supplied;
Building shipyard;
Wagon wagon;
int min_resource, fishermen;

shipyard = This.AsBuilding();
this = shipyard.settlement;
min_resource = GetConst("MinResQtyToTransport");

while (1) {
	Sleep(3000);

	if (.supplied == this)
		.StopSupply();

	supplied = .supplied;

	if (supplied.IsValid)
		if (!.IsEnemy(supplied.player)) {
			if (.gold >= min_resource)
				if (!supplied.IsTTent) {
					if (!supplied.IsShipyard)
						wagon = .CreateMuleGold(1000);
					else if (supplied.WaterLsa != .WaterLsa)
						wagon = .CreateMuleGold(1000);
					else
						wagon = .CreateBoatGold(1000);
					wagon.SetCommand("unload", supplied.GetCentralBuilding());
					wagon.AddCommand(false, "unload", This);//come back if the destination becomes invalid during the travel
				}
			if (.food >= min_resource) {
				if (!supplied.IsShipyard)
					wagon = .CreateMuleFood(1000);
				else if (supplied.WaterLsa != .WaterLsa)
					wagon = .CreateMuleFood(1000);
				else
					wagon = .CreateBoatFood(1000);
				wagon.SetCommand("unload", supplied.GetCentralBuilding());
				wagon.AddCommand(false, "unload", This);//come back if the destination becomes invalid during the travel
			}
		}

	if (shipyard.IsBroken)
		EnvWriteInt(this, "Fishermen", 0);
	else {
		fishermen = EnvReadInt(this, "Fishermen");
		if (fishermen > 0) {
			if (fishermen > 50) {
				fishermen -= 1 + (fishermen - 50) / 5;//reduce by 1 more every 5 over the maximum
				EnvWriteInt(this, "Fishermen", fishermen);
			}
			.SetFood(.food + fishermen * rand(3) / 2);//fishing requires patience and luck
		}
	}
}