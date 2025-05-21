Settlement set;
int i, time;

Sleep(600000);

while (1) {
	time = GetTime();
	for (i = 1; i <= 4; i += 1) {
		set = GetSettlement("Selo" + i);
		if (time > 2400000)
			if (set.food < 4000)
				set.SetFood(set.food + 400);
		if (time > 1800000)
			if (set.food < 4000)
				set.SetFood(set.food + 300);
		if (time > 1200000)
			if (set.food < 4000)
				set.SetFood(set.food + 200);
		if (set.food < 4000)
			set.SetFood(set.food + 80);
	}
	Sleep(12000);
}