Building shipyard;
int timer = 900000;

shipyard = NO_AthensShipyard.obj.AsBuilding();

while (1) {
	Sleep(5000);
	timer -= 5000;
	if (timer <= 0) {
		timer = 900000;
		if (shipyard.player == 2) {
			SpawnNamed("H_Ship");
			SpawnGroupInHolder("H_Reinforcements", H_Ship);
		}
		else if (shipyard.player == 3) {
			SpawnNamed("H_Ship");
			SpawnGroupInHolder("H_Reinforcements", H_Ship);
		}
	}
	if (!H_Ship.IsEmpty()) {
		Ship sh;
		sh = H_Ship.obj.AsShip();
		if (sh.IsValid)
			if (sh.GetUnitsOnBoard().count <= 0)
				sh.Damage(sh.maxhealth);
			else if (sh.command != "unboardall")
				sh.SetCommand("unboardall", GetRandomPointInArea("A_Unboard"));
	}
	else if (!H_Reinforcements.IsEmpty()) {
		Obj town;
		town = NO_Town2;
		if (town.player != 2)
			if (town.player != 3) {
				town = NO_Town3;
				if (town.player != 2)
					if (town.player != 3) {
						town = NO_Town4;
						if (town.player != 2)
							if (town.player != 3) {
								town = NO_Town1;
								if (town.player != 2)
									if (town.player != 3)
										town = NO_Town5;
							}
					}
			}
		if (town.player == 2) {
			H_Reinforcements1.SetPlayer(town.player);
			H_Reinforcements1.SetCommand("advance", town.pos);
			H_Reinforcements1.AddCommand(false, "enter", town);
		}
		else if (town.player == 3) {
			H_Reinforcements1.SetPlayer(town.player);
			H_Reinforcements1.SetCommand("advance", town.pos);
			H_Reinforcements1.AddCommand(false, "enter", town);
		}

		town = NO_Town3;
		if (town.player != 2)
			if (town.player != 3) {
				town = NO_Town2;
				if (town.player != 2)
					if (town.player != 3) {
						town = NO_Town4;
						if (town.player != 2)
							if (town.player != 3) {
								town = NO_Town1;
								if (town.player != 2)
									if (town.player != 3)
										town = NO_Town5;
							}
					}
			}
		if (town.player == 2) {
			H_Reinforcements2.SetPlayer(town.player);
			H_Reinforcements2.SetCommand("advance", town.pos);
			H_Reinforcements2.AddCommand(false, "enter", town);
		}
		else if (town.player == 3) {
			H_Reinforcements2.SetPlayer(town.player);
			H_Reinforcements2.SetCommand("advance", town.pos);
			H_Reinforcements2.AddCommand(false, "enter", town);
		}

		SetNoAIFlag(H_Reinforcements.GetObjList(), false);
		H_Reinforcements.RemoveFromAllGroups();
	}
}