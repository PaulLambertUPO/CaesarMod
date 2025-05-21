// void, Obj This

Place("ChimneySmoke",This.pos+Point(8, 27), This.player);
Sleep(1000);
Place("TempleOfThorFire1", This.pos, This.player);
Sleep(600);
Place("ChimneySmoke",This.pos+Point(-59, -27), This.player);
Sleep(1000);
Place("TempleOfThorFire2", This.pos, This.player);

Sleep(rand(50000) + 10000);
while (1) {
	Sleep(50000);
}
