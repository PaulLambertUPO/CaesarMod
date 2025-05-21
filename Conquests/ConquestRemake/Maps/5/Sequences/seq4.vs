int i;
IntArray tents_counters;

while (1) {
	Sleep(18000);
	for (i = 0; i < 17; i += 1) {
		Settlement set;
		set = GetSettlement("S_Tent" + i);
		if (set.player == 1)
			tents_counters[i] += 1;
		else if (tents_counters[i] != 0)
			tents_counters[i] = 0;
		if (tents_counters[i] >= 10) {
			UnitsInSettlement(set, cUnit).SetPlayer(15);
			set.SetPlayer(15);
			tents_counters[i] = 0;
		}
	}
}