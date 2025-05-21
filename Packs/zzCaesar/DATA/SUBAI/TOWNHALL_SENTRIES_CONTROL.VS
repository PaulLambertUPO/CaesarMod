//void, Obj This

Sleep(rand(301) + 300);

if (GetConst("NoSentries") == 0)
	if (This.AsBuilding().IsValid) {
		Settlement this;

		this = This.AsBuilding().settlement;

		if (.IsValid) {
			int player, add_interval, add_count, curr, max;

			while (.IsIndependent)
				Sleep(5000);

			.AddMaxSentries(GetConst("InitialStrongholdSentries"));//total max = const + 1 per wall + 4 per gate (with const = 20, total max is usually 50-52)

			add_interval = GetConst("SentriesAddTime");
			add_count = GetConst("SentriesAddCount");

			while (1) {
				player = .player;
				Sleep(add_interval);
				if (player == .player) {
					curr = .GetNumSentries();
					max = .GetMaxSentries();
					if (curr < max)
						.AddSentries(MIN(add_count, max - curr));
				}
			}
		}
	}

while (1)
	Sleep(3600000);