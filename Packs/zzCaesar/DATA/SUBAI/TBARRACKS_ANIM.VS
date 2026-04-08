//void, Obj This

Sleep(1 + rand(10));

{
	int i;
	for (i = 1; i <= 5; i += 1)
		Place("TBarrackHorse" + i, This.pos, This.player);
}

while (true)
	Sleep(3600000);