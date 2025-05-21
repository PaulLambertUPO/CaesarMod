IntArray set_numbers;
int i, n;

//villages
set_numbers[0] = 6;
set_numbers[1] = 10;
set_numbers[2] = 12;
set_numbers[3] = 17;
set_numbers[4] = 29;
set_numbers[5] = 31;
set_numbers[6] = 32;
set_numbers[7] = 34;
set_numbers[8] = 35;
set_numbers[9] = 37;
//strongholds
set_numbers[10] = 16;
set_numbers[11] = 25;
set_numbers[12] = 27;
set_numbers[13] = 36;
set_numbers[14] = 40;

for (i = 0; i < 15; i += 1) {
	n = set_numbers[i];
	EnvWriteInt(GetSettlement("S_" + n), "no_villagers", 1);
}

while (NO_40.obj.player == 4) {
	for (i = 1; i < 10; i += 1) {
		n = set_numbers[i];
		if (GetNamedObj("NO_" + n).obj.player == 4)
			GetNamedObj("NO_" + n).SetCommand("tribute", NO_40);
	}
	Sleep(10000);
}