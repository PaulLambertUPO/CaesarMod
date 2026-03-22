//void, Obj owner, Obj attached

if (rand(3) == 0) {
	Hero this;

	this = owner.AsHero();

	if (.IsValid)
		if (!.InHolder) {
			.SetExperience(.experience + 2);
			CreateFeedback("Experience", this);
		}
}