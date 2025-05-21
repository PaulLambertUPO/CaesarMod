int timer = 900000;

while (1) {
	Sleep(5000);
	timer -= 5000;
	if (timer <= 0) {
		timer = 900000;
		if (NO_AthensShipyard.obj.player != 1) {
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
		if (town.player == 1) {
			town = NO_Town3;
			if (town.player == 1)
				town = NO_Town1;
		}
		H_Reinforcements1.SetPlayer(town.player);
		H_Reinforcements1.SetCommand("advanceenter", town);

		town = NO_Town3;
		if (town.player == 1) {
			town = NO_Town2;
			if (town.player == 1)
				town = NO_Town1;
		}
		H_Reinforcements2.SetPlayer(town.player);
		H_Reinforcements2.SetCommand("advanceenter", town);

		SetNoAIFlag(H_Reinforcements.GetObjList(), false);
		H_Reinforcements.RemoveFromAllGroups();
	}
}