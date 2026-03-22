//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (.health >= .maxhealth * 9 / 10) {
		.SetLevel(.inherentlevel + 1);
		.SetHealth(.maxhealth / 10);
		CreateFeedback("Damage1", this);
		ItemUsed(1);
	}