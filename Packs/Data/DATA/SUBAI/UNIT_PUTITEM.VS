// void, Obj me, Item item, Obj h

Unit this;
ItemHolder holder;

this = me.AsUnit();
holder = h.AsItemHolder();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

while(!.Goto(holder, GetConst("GiveDistance"), 1500, true, 5000));
if(!.IsVisible)
	.SetVisible(true);
if (.HasSpecial(sneak)) .SetLastAttackTime(); // mountaineer patch

.PutItem(item, holder); // Ako stane - stane :)
