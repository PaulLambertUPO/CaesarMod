//void, Settlement set

Settlement stronghold;

stronghold = set.BestToSupply;//it returns the nearest owned stronghold

if (stronghold.IsValid) {
	if (set.gold >= 100)
		set.CreateMuleGold(set.gold).SetCommand("unload", stronghold.GetCentralBuilding());
	if (set.food >= 100)
		set.CreateMuleFood(set.food).SetCommand("unload", stronghold.GetCentralBuilding());
}