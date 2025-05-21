// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if(.IsValid() == false)
{
	return;
}

.SetSpeedFactor(150);
.SetWalkAnim(2);

while( (!.Goto(pt, 0, 2000, true, 0)) && (.command() != "enter") );