//void, Obj This

Sleep(rand(301) + 300);

if (GetConst("NoSentries") == 0)
	if (This.AsBuilding().IsValid) {
		Settlement this;

		this = This.AsBuilding().settlement;

		while (.IsIndependent)
			Sleep(5000);

		{
			int plr, add_interval, add_count;

			.AddMaxSentries(GetConst("InitialStrongholdSentries"));//total max = const + 1 per wall + 4 per gate (with const = 20, total max is usually 50-52)

			add_interval = GetConst("SentriesAddTime");
			add_count = GetConst("SentriesAddCount");

			while (1) {
				if (plr == .player)
					.AddSentries(CLAMP(.GetMaxSentries() - .GetNumSentries(), 0, add_count));
				else
					plr = .player;

				Sleep(add_interval);
			}
		}
	}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);