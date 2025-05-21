ObjList ol;
Unit u;
int i;

while (1) {
	ol = GetPlayerUnits(1);
	for (i = 0; i < ol.count; i += 1) {
		u = ol[i].AsUnit();
		if (u.IsValid) {
			u.SetFeeding(false);
			if (u.AsHero().IsValid)
				u.AsHero().SetSkill(hsSurvival, -1);
			if (u.IsHeirOf(cMilitary))
				if (u.GetHolderSett().IsStronghold()) {
					if (!u.HasItem("Health charm"))
						u.AddItem("Health charm");
					if (!u.HasItem("Damage charm"))
						u.AddItem("Damage charm");
					if (!u.HasItem("Armor charm"))
						u.AddItem("Armor charm");
					if (!u.HasItem("Knowledge charm"))
						u.AddItem("Knowledge charm");
				}
		}
	}
	Sleep(1000);
}