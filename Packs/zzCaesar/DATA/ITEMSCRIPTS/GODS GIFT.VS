//void, Obj owner, Obj victim

if (victim.AsUnit().IsValid) {
	Unit this;

	this = owner.AsUnit();

	if (.IsValid) {
		if (.health < .maxhealth)
			.Heal(.maxhealth);
		.RemoveItem("God's Gift");
	}
}