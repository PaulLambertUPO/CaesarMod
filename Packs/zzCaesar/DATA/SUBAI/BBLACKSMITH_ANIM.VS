//void, Obj This

Sleep(1 + rand(10));

Place("BBlacksmithFire", This.pos, This.player);

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(-96, -86), This.player);

//without this instruction, the game crashes
while (true)
	Sleep(86400000);