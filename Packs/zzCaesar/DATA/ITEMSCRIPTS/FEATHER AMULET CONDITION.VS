//void, Obj owner

if (owner.IsValid) {
	Item this;
	int i, feathers;

	for (i = 1; i <= owner.items_count; i += 1)
		if (owner.GetItem(i).name == "Eagle feather")
			feathers += 1;
	if (feathers > 2) {
		this = owner.FindItem("Eagle feather");
		if (owner.AsUnit().IsValid)
			CreateFeedback("GetItem", owner.AsUnit());
		owner.ExchangeItem(this, "Feather amulet");
		owner.RemoveItem("Eagle feather");
		owner.RemoveItem("Eagle feather");
	}
}