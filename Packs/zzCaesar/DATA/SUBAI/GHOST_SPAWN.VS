//void, Obj This

Ghost this;

this = This.AsGhost();

if (.IsValid)
	if (.IsAlive)
		.PlayAnim(17, .pos);

Sleep(15);//prevent possible loops with other commands