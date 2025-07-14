//void, Obj owner, Obj attached

Hero this;

this = owner.AsHero();

if (.IsValid)
	if (rand(3) == 0) {
		.SetExperience(.experience + 2);
		if (!.InHolder)
			CreateFeedback("Experience", this);
	}