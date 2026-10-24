//void, Obj This

Sleep(1 + rand(10));

Place("TBlacksmithFire", This.pos, This.player);

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(155, -40), This.player);

//without this instruction, the game crashes
while (true)
	Sleep(86400000);