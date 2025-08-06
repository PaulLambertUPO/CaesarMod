//void, Obj This

Sleep(rand(10) + 1);

Place("TempleOfThorFire1", This.pos, This.player);

Sleep(rand(10) + 1);

Place("ChimneySmoke", This.pos + Point(8, 27), This.player);

Sleep(rand(10) + 1);

Place("TempleOfThorFire2", This.pos, This.player);

Sleep(rand(10) + 1);

Place("ChimneySmoke", This.pos + Point(-59, -27), This.player);

while (1)
	Sleep(3600000);