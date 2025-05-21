Query units_to_board;

units_to_board = Intersect(ClassPlayerAreaObjs("Unit", 2, "A_RomeSupportZone"), T_AttS_Sett37);

while (1) {
	Sleep(2000);
	if (T_Sh_Sett37.IsEmpty())
		if (!units_to_board.IsEmpty()) {
			ObjList ol_ships, ol_units;
			Ship sh;
			int i, j;

			ol_ships = SpawnGroup("T_Sh_Sett37");
			for (i = 0; i < ol_ships.count; i += 1) {
				if (units_to_board.IsEmpty()) {
					T_Sh_Sett37.SetCommand("idle");
					break;
				}
				sh = ol_ships[i].AsShip();
				while (sh.IsValid) {
					if (sh.UnitsCount < 120) {
						units_to_board.AddToGroup("Special37");
						ol_units = Group("Special37").GetObjList();
						for (j = 0; j < 120 && j < ol_units.count; j += 1)
							ol_units[j].AddToGroup("TEMP37");
						Group("TEMP37").RemoveFromGroup("Special37");
						Group("TEMP37").SetCommand("boardship", sh);
						sh.GetUnitsOnBoard().RemoveFromGroup("TEMP37");
						sh.SetCommand("idle");
						if (units_to_board.IsEmpty()) {
							sh.GetUnitsOnBoard().SetCommand("idle");
							break;
						}
					}
					else
						break;
					Sleep(5000);
				}
			}
			for (i = 0; i < ol_ships.count; i += 1) {
				sh = ol_ships[i].AsShip();
				if (sh.IsValid) {
					sh.GetUnitsOnBoard().RemoveFromAllGroups();
					sh.GetUnitsOnBoard().AddToGroup("Take_S_Sett37");
				}
			}
			while (!T_Sh_Sett37.IsEmpty()) {
				for (i = 0; i < ol_ships.count; i += 1) {
					sh = ol_ships[i].AsShip();
					if (sh.IsValid)
						if (sh.GetUnitsOnBoard().count == 0)
							sh.Damage(sh.maxhealth);
						else
							sh.SetCommand("unboardall", GetRandomPointInArea("A_RDrop1"));
				}
				Sleep(3000);
			}
			if (NO_37.obj.IsEnemy(NO_1.obj))
				if (!IsAIHelperRunning("Take_Sett37"))
					if (!Group("Take_S_Sett37").IsEmpty())
						RunAIHelper("Take_Sett37", "siege", "Take_S_Sett37", "S_Sett37");
		}
}