// void, Obj me, Item item, point pt

Unit this;
ItemHolder holder;

this = me.AsUnit();

if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);

while(!.Goto(pt, GetConst("GiveDistance"), 1500, true, 5000));
.DropItem(item, pt); // Ako stane - stane :)
