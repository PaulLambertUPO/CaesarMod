//void, Obj this

.Progress();

{
	Settlement set;

	set = .AsBuilding().settlement;

	set.SetGold(set.gold + 500);
	set.GoldConverted(500);
}