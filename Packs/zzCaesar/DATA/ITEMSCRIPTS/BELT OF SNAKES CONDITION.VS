//void, Obj owner

if (owner.IsValid) {
	int i, skins;

	for (i = owner.items_count; i >= 1; i -= 1)
		if (owner.GetItem(i).name == "Snake skin") {
			skins += 1;
			if (skins >= 3) {
				Unit u;

				owner.ExchangeItem(owner.FindItem("Snake skin"), "Belt of snakes");
				owner.RemoveItem("Snake skin");
				owner.RemoveItem("Snake skin");

				u = owner.AsUnit();

				if (u.IsValid)
					if (!u.InHolder)
						CreateFeedback("GetItem", u);

				return;
			}
		}
}