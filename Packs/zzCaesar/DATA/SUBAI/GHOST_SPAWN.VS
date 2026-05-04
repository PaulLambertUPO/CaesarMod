//void, Obj This

Ghost this;

this = This.AsGhost();

if (.IsValid)
	if (.IsAlive)
		.PlayAnim(17, .pos);

Sleep(30);//prevent possible loops with other commands