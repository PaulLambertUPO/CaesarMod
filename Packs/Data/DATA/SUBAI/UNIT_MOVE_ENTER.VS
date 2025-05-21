//void, Obj This, point pt

Unit this;
this = This.AsUnit();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

.SetEntering(true);
while(!.GotoEnter(pt,0,2000,false,0));