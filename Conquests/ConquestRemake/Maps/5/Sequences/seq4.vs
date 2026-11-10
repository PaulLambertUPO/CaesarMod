Settlement set;
IntArray tents_counters;
int i;

while (true) {
	Sleep(18000);
	for (i = 0; i < 17; i += 1) {
		set = GetSettlement("S_Tent" + i);
		if (set.player == 1)
			tents_counters[i] += 1;
		else if (tents_counters[i] != 0)
			tents_counters[i] = 0;
		if (tents_counters[i] >= 10) {
			set.SetPlayer(15);
			tents_counters[i] = 0;
		}
	}
}