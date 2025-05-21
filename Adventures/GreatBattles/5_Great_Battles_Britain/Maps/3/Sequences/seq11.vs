Query units_to_board;

units_to_board = Intersect(ClassPlayerAreaObjs("Unit", 2, "A_RomeSupportZone"), T_S_Sett1Guards);

while (1) {
	Sleep(2000);
	if (T_Sh_Sett1.IsEmpty())
		if (!units_to_board.IsEmpty()) {
			ObjList ol_ships, ol_units;
			Ship sh;
			int i, j;

			ol_ships = SpawnGroup("T_Sh_Sett1");
			for (i = 0; i < ol_ships.count; i += 1) {
				if (units_to_board.IsEmpty()) {
					T_Sh_Sett1.SetCommand("idle");
					break;
				}
				sh = ol_ships[i].AsShip();
				while (sh.IsValid) {
					if (sh.UnitsCount < 120) {
						units_to_board.AddToGroup("SpecialDef");
						ol_units = Group("SpecialDef").GetObjList();
						for (j = 0; j < 120 && j < ol_units.count; j += 1)
							ol_units[j].AddToGroup("TEMP1");
						Group("TEMP1").RemoveFromGroup("SpecialDef");
						Group("TEMP1").SetCommand("boardship", sh);
						sh.GetUnitsOnBoard().RemoveFromGroup("TEMP1");
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
					sh.GetUnitsOnBoard().AddToGroup("T_S_Sett1");
				}
			}
			while (!T_Sh_Sett1.IsEmpty()) {
				for (i = 0; i < ol_ships.count; i += 1) {
					sh = ol_ships[i].AsShip();
					if (sh.IsValid)
						if (sh.GetUnitsOnBoard().count <= 0)
							sh.Damage(sh.maxhealth);
						else
							sh.SetCommand("unboardall", GetRandomPointInArea("A_RDrop2"));
				}
				Sleep(3000);
			}
			if (!T_S_Sett1.IsEmpty()) {
				T_S_Sett1.SetPlayer(1);
				T_S_Sett1.SetFeeding(true);
				T_S_Sett1.SetCommand("advanceenter", NO_1);
				T_S_Sett1.RemoveFromAllGroups();
			}
		}
}