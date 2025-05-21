//void, Obj This

Building this;
Settlement set;
int gain;

this = This.AsBuilding();

.Progress(.cmddelay);

set = .settlement;

gain = GetConst("InvestmentGoldRevenue");

set.GoldSpent(-4000);
set.SetGold(set.gold + gain);
set.GoldConverted(gain - 4000);