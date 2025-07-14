//void, Obj owner

if (owner.IsValid) {
	int i, teeth;

	for (i = 1; i <= owner.items_count; i += 1)
		if (owner.GetItem(i).name == "Boar tooth")
			teeth += 1;

	if (teeth > 2) {
		Unit u;

		u = owner.AsUnit();

		if (u.IsValid)
			if (u.InHolder)
				CreateFeedback("GetItem", u);

		owner.ExchangeItem(owner.FindItem("Boar tooth"), "Boar teeth");
		owner.RemoveItem("Boar tooth");
		owner.RemoveItem("Boar tooth");
	}
}