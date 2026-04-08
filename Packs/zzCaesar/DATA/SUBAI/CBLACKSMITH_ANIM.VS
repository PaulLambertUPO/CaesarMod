//void, Obj This

Sleep(1 + rand(10));

Place("CBlacksmithAnim", This.pos, This.player);

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(-104, -110), This.player);

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(-134, -110), This.player);

while (true)
	Sleep(3600000);