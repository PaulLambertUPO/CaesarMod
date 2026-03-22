//void, Obj owner

if (owner.IsValid) {
	Item item;
	int i, teeth;

	for (i = owner.items_count; i >= 1; i -= 1) {
		item = owner.GetItem(i);
		if (item.IsValid)
			if (item.name == "Boar tooth") {
				teeth += 1;
				if (teeth >= 3) {
					owner.ExchangeItem(owner.FindItem("Boar tooth"), "Boar teeth");
					owner.RemoveItem("Boar tooth");
					owner.RemoveItem("Boar tooth");

					CreateFeedback("GetItem", owner.posRH);

					return;
				}
			}
	}
}