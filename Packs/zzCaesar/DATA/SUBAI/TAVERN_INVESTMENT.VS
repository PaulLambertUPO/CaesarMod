//void, Obj this

Settlement set;
int gain;

set = .AsBuilding().settlement;

.Progress();

gain = GetConst("InvestmentGoldRevenue");

set.GoldSpent(-4000);
set.SetGold(set.gold + gain);
set.GoldConverted(gain - 4000);