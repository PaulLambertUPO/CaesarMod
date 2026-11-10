ObjList ol;
Unit u;
int i;

while (true) {
	ol = GetPlayerUnits(1);
	for (i = ol.count - 1; i >= 0; i -= 1) {
		u = ol[i].AsUnit();
		if (u.IsAlive) {
			u.SetFeeding(false);
			if (u.AsHero().IsValid)
				u.AsHero().SetSkill(hsSurvival, -1);
			if (u.IsMilitary)
				if (u.GetHolderSett().IsStronghold) {
					if (!u.HasItem("Charm of Ra"))
						u.AddItem("Charm of Ra");
					if (!u.HasItem("Charm of Seth"))
						u.AddItem("Charm of Seth");
					if (!u.HasItem("Charm of Thoth"))
						u.AddItem("Charm of Thoth");
					if (!u.HasItem("Charm of Isis"))
						u.AddItem("Charm of Isis");
				}
		}
	}
	Sleep(1000);
}