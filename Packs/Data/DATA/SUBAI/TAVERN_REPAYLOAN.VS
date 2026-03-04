//void, Obj This

Settlement this;
int remaining_gold;

this = This.AsBuilding().settlement;

remaining_gold = .gold - .loan;

.SetGold(MAX(0, remaining_gold));
.SetLoan(MAX(0, -remaining_gold));