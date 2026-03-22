//void, Obj owner

if (owner.IsValid) {
	Item item;
	int i, skins;

	for (i = owner.items_count; i >= 1; i -= 1) {
		item = owner.GetItem(i);
		if (item.IsValid)
			if (item.name == "Snake skin") {
				skins += 1;
				if (skins >= 3) {
					owner.ExchangeItem(owner.FindItem("Snake skin"), "Belt of snakes");
					owner.RemoveItem("Snake skin");
					owner.RemoveItem("Snake skin");

					CreateFeedback("GetItem", owner.posRH);

					return;
				}
			}
	}
}