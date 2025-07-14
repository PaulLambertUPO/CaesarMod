//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid)
	if (.health >= .maxhealth * 9 / 10) {//owner needs at least 90% maximum health in order to use the item
		.SetLevel(.inherentlevel + 1);
		.SetHealth(.maxhealth / 10);
		if (!.InHolder)
			CreateFeedback("Damage1", this);
		ItemUsed(1);
	}