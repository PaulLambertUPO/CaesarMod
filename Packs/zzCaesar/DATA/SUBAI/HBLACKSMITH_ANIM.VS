//void, Obj This

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(-116, -176), This.player);

//without this instruction, the game crashes
while (true)
	Sleep(86400000);