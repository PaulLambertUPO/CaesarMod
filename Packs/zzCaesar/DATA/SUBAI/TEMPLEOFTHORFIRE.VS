//void, Obj This

Sleep(1 + rand(10));

Place("TempleOfThorFire1", This.pos, This.player);

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(8, 27), This.player);

Sleep(1 + rand(10));

Place("TempleOfThorFire2", This.pos, This.player);

Sleep(1 + rand(10));

Place("ChimneySmoke", This.pos + Point(-59, -27), This.player);

while (true)
	Sleep(3600000);