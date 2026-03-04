//void, Obj owner

if (owner.IsValid) {
	int i, feathers;

	for (i = owner.items_count; i >= 1; i -= 1)
		if (owner.GetItem(i).name == "Eagle feather") {
			feathers += 1;
			if (feathers >= 3) {
				Unit u;

				owner.ExchangeItem(owner.FindItem("Eagle feather"), "Feather amulet");
				owner.RemoveItem("Eagle feather");
				owner.RemoveItem("Eagle feather");

				u = owner.AsUnit();

				if (u.IsValid)
					if (!u.InHolder)
						CreateFeedback("GetItem", u);

				return;
			}
		}
}