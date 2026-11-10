//void, Obj this

.Progress();

{
	Settlement set;

	set = .AsBuilding().settlement;

	set.GoldSpent(-4000);
	set.SetGold(set.gold + 6500);
	set.GoldConverted(2500);

	UserNotification("investment completed", "", .pos, .player);
}