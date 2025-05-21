//void, Obj owner

Unit this;
Settlement set;

this = owner.AsUnit;

if (!.IsValid())
 return;

while (1) {
 Sleep(1000);
 if (.InHolder){
	set = .GetHolderSett();
	set.SetGold(set.gold + 1);
	if (set.gold) {
		set.SetGold(set.gold + GetUseCount() - 1);
		ItemUsed(GetUseCount());
		return;
	}
 }
}