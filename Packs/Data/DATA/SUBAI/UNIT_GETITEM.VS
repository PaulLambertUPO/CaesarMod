// void, Obj me, Item item, Obj h

Unit this;

this = me.AsUnit();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

//.pr("chasing unit to give him something");

while(!.Goto(h, GetConst("GiveDistance"), 1500, true, 5000));
if(!.IsVisible)
	.SetVisible(true);
if (.HasSpecial(sneak)) .SetLastAttackTime(); // mountaineer patch
h.GiveItem(item, this); // Ako stane - stane :)