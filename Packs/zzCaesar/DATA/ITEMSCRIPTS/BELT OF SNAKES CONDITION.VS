//void, Obj owner

if (owner.IsValid) {
	Item this;
	int i, skins;

	for (i = 1; i <= owner.items_count; i += 1)
		if (owner.GetItem(i).name == "Snake skin")
			skins += 1;
	if (skins > 2) {
		this = owner.FindItem("Snake skin");
		if (owner.AsUnit().IsValid)
			CreateFeedback("GetItem", owner.AsUnit());
		owner.ExchangeItem(this, "Belt of snakes");
		owner.RemoveItem("Snake skin");
		owner.RemoveItem("Snake skin");
	}
}