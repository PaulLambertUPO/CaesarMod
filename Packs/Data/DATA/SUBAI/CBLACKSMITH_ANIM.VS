//void, Obj This

Sleep(rand(10) + 1);

Place("CBlacksmithAnim", This.pos, This.player);

Sleep(rand(10) + 1);

Place("ChimneySmoke", This.pos + Point(-104, -110), This.player);

Sleep(rand(10) + 1);

Place("ChimneySmoke", This.pos + Point(-134, -110), This.player);

while (1)
	Sleep(3600000);