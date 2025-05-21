//void, Obj owner, Obj attached

if (rand(3) == 0) {
	Unit this;
	this = owner.AsUnit();
	.SetExperience(.experience + 2);
	if (!.InHolder)
		CreateFeedback("Experience", this);
}