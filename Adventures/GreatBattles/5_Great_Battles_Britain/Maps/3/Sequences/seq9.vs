Query units_to_board;

units_to_board = Intersect(ClassPlayerAreaObjs("Unit", 2, "A_RomeSupportZone"), T_AttS_Sett29);

while (1) {
	Sleep(2000);
	if (T_Sh_Sett29.IsEmpty())
		if (!units_to_board.IsEmpty()) {
			ObjList ol_ships, ol_units;
			Ship sh;
			int i, j;

			ol_ships = SpawnGroup("T_Sh_Sett29");
			for (i = 0; i < ol_ships.count; i += 1) {
				if (units_to_board.IsEmpty()) {
					T_Sh_Sett29.SetCommand("idle");
					break;
				}
				sh = ol_ships[i].AsShip();
				while (sh.IsValid) {
					if (sh.UnitsCount < 120) {
						units_to_board.AddToGroup("Special29");
						ol_units = Group("Special29").GetObjList();
						for (j = 0; j < 120 && j < ol_units.count; j += 1)
							ol_units[j].AddToGroup("TEMP29");
						Group("TEMP29").RemoveFromGroup("Special29");
						Group("TEMP29").SetCommand("boardship", sh);
						sh.GetUnitsOnBoard().RemoveFromGroup("TEMP29");
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
					sh.GetUnitsOnBoard().AddToGroup("Take_S_Sett29");
				}
			}
			while (!T_Sh_Sett29.IsEmpty()) {
				for (i = 0; i < ol_ships.count; i += 1) {
					sh = ol_ships[i].AsShip();
					if (sh.IsValid)
						if (sh.GetUnitsOnBoard().count == 0)
							sh.Damage(sh.maxhealth);
						else
							sh.SetCommand("unboardall", GetRandomPointInArea("EDrop2"));
				}
				Sleep(3000);
			}
			if (NO_29.obj.IsEnemy(NO_1.obj))
				if (!IsAIHelperRunning("Take_Sett29"))
					if (!Group("Take_S_Sett29").IsEmpty())
						RunAIHelper("Take_Sett29", "siege", "Take_S_Sett29", "S_Sett29");
		}
}