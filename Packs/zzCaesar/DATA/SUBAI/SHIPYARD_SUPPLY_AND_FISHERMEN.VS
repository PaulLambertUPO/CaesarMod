//void, Obj This

Settlement this, supp;
Building shipyard;
Wagon wagon;
int min_resource, wLsa, fishermen;

Sleep(250 + rand(251));

shipyard = This.AsBuilding();
this = shipyard.settlement;
min_resource = GetConst("MinResQtyToTransport");
wLsa = .WaterLsa;

while (true) {
	if (.supplied == this)
		.StopSupply();

	supp = .supplied;

	if (supp.IsValid)
		if (!.IsEnemy(supp.player)) {
			if (.gold >= min_resource)
				if (!supp.IsTTent) {
					if (!supp.IsShipyard)
						wagon = .CreateMuleGold(1000);
					else if (supp.WaterLsa != wLsa)
						wagon = .CreateMuleGold(1000);
					else
						wagon = .CreateBoatGold(1000);
					wagon.SetCommand("unload", supp.GetCentralBuilding());
					wagon.AddCommand(false, "unload", This);//come back if the destination becomes invalid during the travel
				}
			if (.food >= min_resource) {
				if (!supp.IsShipyard)
					wagon = .CreateMuleFood(1000);
				else if (supp.WaterLsa != wLsa)
					wagon = .CreateMuleFood(1000);
				else
					wagon = .CreateBoatFood(1000);
				wagon.SetCommand("unload", supp.GetCentralBuilding());
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

	Sleep(3000);
}