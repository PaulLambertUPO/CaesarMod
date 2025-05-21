int i, ship_interval, timer;
bool talked = false;

ship_interval = 420000 - GetDifficulty() * 60000;

timer = ship_interval;

while (1) {
	Sleep(10000);
	timer -= 10000;
	if (timer <= 0) {
		timer = ship_interval;
		if (NO_AlexandriaShipyard.obj.player == 4)
			if (NO_AlexandriaShipyard.obj.health >= 1200) {
				SpawnGroup("E_AlexandriaFleet");
				SpawnGroupInHolder("E_AlexandriaCrew1", E_AlexandriaShip1);
				SpawnGroupInHolder("E_AlexandriaCrew2", E_AlexandriaShip2);
			}
	}
	if (!E_AlexandriaFleet.IsEmpty()) {
		ObjList ships;
		Ship sh;
		ships = E_AlexandriaFleet.GetObjList();
		ships.ClearDead();
		for (i = 0; i < ships.count; i += 1) {
			sh = ships[i].AsShip();
			if (sh.IsValid)
				if (sh.GetUnitsOnBoard().count <= 0)
					sh.Damage(sh.maxhealth);
				else if (sh.command != "unboardall")
					sh.SetCommand("unboardall", GetRandomPointInArea("A_DropPelusio"));
		}
	}
	else if (!E_AlexandriaCrew.IsEmpty()) {
		E_AlexandriaCrew.SetCommand("advance", NO_Pelusio.obj.pos);
		E_AlexandriaCrew.AddCommand(false, "capture", NO_Pelusio);
		if (!talked) {
			RunConv("Shipyards");
			GiveNote("AlexandriaShipyard");
			talked = true;
		}
	}
}