// void, Obj This

Place("CBlacksmithAnim", This.pos, This.player);

Place("ChimneySmoke",This.pos+Point(-104, -110), This.player);
Sleep(1000);
Place("ChimneySmoke",This.pos+Point(-134, -110), This.player);

Sleep(rand(50000) + 10000);
while (1) {
	Sleep(50000);
}
