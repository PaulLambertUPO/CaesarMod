//void, int player

if (EnvReadString(player, "GovernmentForm") == "Democracy") {
	ObjList ol;
	Obj o;
	int i, j;

	while (true) {
		for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
			ol = GetPlayerUnits(i, "Military");
			for (j = ol.count - 1; j >= 0; j -= 1) {
				o = ol[j];
				if (o.IsAlive)
					if (o.player == player) {//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
						if (o.HasItem("Emblem of Oligarchy"))
							o.RemoveItem("Emblem of Oligarchy");
						if (o.free_item_slots > 0)
							if (!o.IsSentry)
								if (!o.AsHero().IsValid)
									if (!o.HasItem("Emblem of Democracy"))
										o.AddItem("Emblem of Democracy");
					}
			}
		}
		Sleep(1000);
	}
}
else if (EnvReadString(player, "GovernmentForm") == "Oligarchy") {
	ObjList ol;
	Obj o;
	int i, j;

	while (true) {
		for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
			ol = GetPlayerUnits(i, "Military");
			for (j = ol.count - 1; j >= 0; j -= 1) {
				o = ol[j];
				if (o.IsAlive)
					if (o.player == player) {//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
						if (o.HasItem("Emblem of Democracy"))
							o.RemoveItem("Emblem of Democracy");
						if (o.free_item_slots > 0)
							if (o.AsUnit().inherentlevel >= 6)
								if (!o.IsSentry)
									if (!o.AsHero().IsValid)
										if (!o.HasItem("Emblem of Oligarchy"))
											o.AddItem("Emblem of Oligarchy");
					}
			}
		}
		Sleep(1000);
	}
}