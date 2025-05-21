//void, Settlement set

Settlement dest;
dest = set.BestToSupply();
if (dest.IsValid) {
	Wagon wagon;
	if (set.gold >= 100) {
		wagon = set.CreateMuleGold(set.gold);
		if (wagon.IsValid) {
			wagon.AddCommand(false, "unload", dest.GetCentralBuilding());
			wagon.KillCommand();
		}
	}
	if (set.food >= 100) {
		wagon = set.CreateMuleFood(set.food);
		if (wagon.IsValid) {
			wagon.AddCommand(false, "unload", dest.GetCentralBuilding());
			wagon.KillCommand();
		}
	}
}