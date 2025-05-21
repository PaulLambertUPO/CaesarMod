//void, Obj This

ObjList units;
Unit u;
str gov_form;
int player, i, j;

while (1) {
	player = This.player;
	gov_form = EnvReadString(player, "GovernmentForm");

	if (gov_form == "Democracy")
		for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
			units = GetPlayerUnits(i, "Military");
			units.ClearDead();
			for (j = 0; j < units.count; j += 1) {
				u = units[j].AsUnit();
				if (u.IsValid)
					if (u.player == player) {//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
						if (u.HasItem("Emblem of Oligarchy"))
							u.RemoveItem("Emblem of Oligarchy");
						if (u.free_item_slots > 0)
							if (!u.IsSentry)
								if (!u.IsHeirOf("Hero"))
									if (!u.HasItem("Emblem of Democracy"))
										u.AddItem("Emblem of Democracy");
					}
			}
		}
	else if (gov_form == "Oligarchy")
		for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
			units = GetPlayerUnits(i, "Military");
			units.ClearDead();
			for (j = 0; j < units.count; j += 1) {
				u = units[j].AsUnit();
				if (u.IsValid)
					if (u.player == player) {//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
						if (u.HasItem("Emblem of Democracy"))
							u.RemoveItem("Emblem of Democracy");
						if (u.inherentlevel >= 6)
							if (u.free_item_slots > 0)
								if (!u.IsSentry)
									if (!u.IsHeirOf("Hero"))
										if (!u.HasItem("Emblem of Oligarchy"))
											u.AddItem("Emblem of Oligarchy");
					}
			}
		}

	Sleep(1000);
}