// void, Obj This, point pt

Druid this;
Obj obj;

this = This.AsDruid();
if (!.IsValid()) return;
if (.AI) if(IsProtected(.player, .pos, "CoverOfMercy"))
	return;

while (!.Goto(pt, .sight, 2000, false, 2500));

.PlayAnim(18, .pos);
obj = Place("CoverOfMercy", pt, .player);
obj.SetStamina(10);
.Damage(.health);
