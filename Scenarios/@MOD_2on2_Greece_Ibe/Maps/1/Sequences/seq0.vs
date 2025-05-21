int i, j;

for (i = 1; i <= 4; i += 1)
	for (j = 5; j <= 8; j += 1) {
		DiplCeaseFire(i, j, true);
		DiplCeaseFire(j, i, true);
		DiplShareView(i, j, true);
		DiplShareView(j, i, true);
	}