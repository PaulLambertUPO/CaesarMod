//void, Obj This

Sleep(rand(301) + 300);

if (GetConst("NoSentries") == 0)
	if (This.AsBuilding().IsValid) {
		Settlement this;

		this = This.AsBuilding().settlement;

		if (.IsValid) {
			int player, add_interval, add_count, missing_sentries;

			while (.IsIndependent)
				Sleep(5000);

			.AddMaxSentries(GetConst("InitialStrongholdSentries"));//total max = const + 1 per wall + 4 per gate (with const = 20, total max is usually 50-52)

			add_interval = GetConst("SentriesAddTime");
			add_count = GetConst("SentriesAddCount");

			Sleep(add_interval);

			while (1) {
				if (player == .player) {
					missing_sentries = .GetMaxSentries() - .GetNumSentries();
					if (missing_sentries > 0)
						.AddSentries(MIN(add_count, missing_sentries));
				}
				else
					player = .player;

				Sleep(add_interval);
			}
		}
	}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);