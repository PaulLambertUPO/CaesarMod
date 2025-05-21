//void, int player

ObjList ol;
Unit u;
int i, j, c;

while (1) {
	for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
		ol = GetPlayerUnits(i, "Military");
		ol.ClearDead();
		c = ol.count;
		for (j = 0; j < c; j += 1) {
			u = ol[j].AsUnit();
			if (u.IsValid)
				if (u.player == player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
					if (!u.AsHero().IsValid) {
						u.SetExperience(u.experience + 1);
						if (!u.InHolder)
							CreateFeedback("Experience", u);
					}
		}
	}
	Sleep(30000);
}