//void, Obj This

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(-44, 48), This.player);

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(-7, -238), This.player);

//without this instruction, the game crashes
while (true)
	Sleep(86400000);