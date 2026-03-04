//void, Obj owner, Obj victim

if (victim.AsUnit().IsValid) {
	Unit this;

	this = owner.AsUnit();

	if (.IsValid) {
		if (.health < .maxhealth) {
			.Heal(.maxhealth);
			CreateFeedback("Heal", this);
		}
		.RemoveItem(.GetItemIndex(GetThis()));
	}
}