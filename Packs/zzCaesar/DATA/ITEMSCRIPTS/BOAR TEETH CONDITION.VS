//void, Obj owner

if (owner.IsValid) {
	Item this;
	int i, teeth;

	for (i = 1; i <= owner.items_count; i += 1)
		if (owner.GetItem(i).name == "Boar tooth")
			teeth += 1;
	if (teeth > 2) {
		this = owner.FindItem("Boar tooth");
		if (owner.AsUnit().IsValid)
			CreateFeedback("GetItem", owner.AsUnit());
		owner.ExchangeItem(this, "Boar teeth");
		owner.RemoveItem("Boar tooth");
		owner.RemoveItem("Boar tooth");
	}
}