//void, Obj owner

if (owner.IsValid) {
	Item item;
	int i, feathers;

	for (i = owner.items_count; i >= 1; i -= 1) {
		item = owner.GetItem(i);
		if (item.IsValid)
			if (item.name == "Eagle feather") {
				feathers += 1;
				if (feathers >= 3) {
					owner.ExchangeItem(owner.FindItem("Eagle feather"), "Feather amulet");
					owner.RemoveItem("Eagle feather");
					owner.RemoveItem("Eagle feather");

					CreateFeedback("GetItem", owner.posRH);

					return;
				}
			}
	}
}