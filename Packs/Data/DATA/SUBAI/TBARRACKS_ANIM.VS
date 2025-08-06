//void, Obj This

Sleep(rand(10) + 1);

{
	int i;
	for (i = 1; i <= 5; i += 1)
		Place("TBarrackHorse" + i, This.pos, This.player);
}

while (1)
	Sleep(3600000);