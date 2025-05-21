// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if(.IsValid() == false)
	return;

if(.IsValid() == true) // leave parry mode at new command
	.SetParryMode(false);
	
.SetSpeedFactor(150);
.SetWalkAnim(2);

if(.player() >= 13)
{
	.SetCommand("trot", pt);
}
else
{
	.SetCommand("galop", pt);
}

//while ( (!.Goto(pt, 0, 50, true, 0)) && (.command() != "enter") );