//void, Obj this

.Progress();

{
	Settlement set;

	set = .AsBuilding().settlement;

	set.GoldSpent(-4000);
	set.SetGold(set.gold + 6000);
	set.GoldConverted(2000);

	UserNotification("investment completed", "", .pos, .player);
}