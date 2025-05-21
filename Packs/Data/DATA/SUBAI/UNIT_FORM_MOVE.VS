// void, Obj This

Unit  this;
point pt;

this = This.AsUnit ();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

.FormAcceptMove();
while (.HasPath()) {
	.FormKeepMoving (1000);
}

if(.hero.IsValid) {
	pt = .hero.GetFinalPartyOrientation() - Point(1024, 1024);
	if (pt.x == 0 && pt.y == 0)
		pt = .hero.GetDir();
	.Face(.pos + pt);
}

