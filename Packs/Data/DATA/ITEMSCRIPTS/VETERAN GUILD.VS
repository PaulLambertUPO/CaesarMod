//void, Obj owner, Obj victim

if (owner.AsUnit().IsValid) {
	Item this;

	this = owner.FindItem("Veteran Guild");

	if (.IsValid)
		owner.ExchangeItem(this, "Veteran Medal");
}