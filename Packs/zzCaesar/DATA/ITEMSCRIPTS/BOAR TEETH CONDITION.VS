//void, Obj owner

if (owner.IsValid) {
	int i, teeth;

	for (i = owner.items_count; i >= 1; i -= 1)
		if (owner.GetItem(i).name == "Boar tooth") {
			teeth += 1;
			if (teeth >= 3) {
				Unit u;

				owner.ExchangeItem(owner.FindItem("Boar tooth"), "Boar teeth");
				owner.RemoveItem("Boar tooth");
				owner.RemoveItem("Boar tooth");

				u = owner.AsUnit();

				if (u.IsValid)
					if (!u.InHolder)
						CreateFeedback("GetItem", u);

				return;
			}
		}
}