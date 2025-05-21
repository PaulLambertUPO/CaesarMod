// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if(.IsValid() == false)
{
	return;
}

.SetSpeedFactor(60);
.SetWalkAnim(1);

while( (!.Goto(pt, 0, 2000, true, 0)) && (.command() != "enter") );