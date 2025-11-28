//void, Settlement set

Settlement stronghold;

stronghold = set.BestToSupply;//it returns the nearest owned stronghold

if (stronghold.IsValid) {
	Wagon mule;

	if (set.gold >= 100) {
		mule = set.CreateMuleGold(set.gold);
		if (mule.IsValid)
			mule.SetCommand("unload", stronghold.GetCentralBuilding());
	}
	if (set.food >= 100) {
		mule = set.CreateMuleFood(set.food);
		if (mule.IsValid)
			mule.SetCommand("unload", stronghold.GetCentralBuilding());
	}
}