//void, Obj This

Sleep(300 + rand(701));

if (GetConst("NoSentries") == 0)
	if (This.AsBuilding().IsValid) {
		Settlement this;

		this = This.AsBuilding().settlement;

		while (.IsIndependent)
			Sleep(5000);

		{
			int plr, missing_sentries;

			.AddMaxSentries(20);//total max = 20 + 1 per wall + 4 per gate (total max is usually 50-52)

			while (1) {
				if (plr == .player) {
					missing_sentries = .GetMaxSentries() - .GetNumSentries();
					if (missing_sentries > 0)
						.AddSentries(MIN(4, missing_sentries));
				}
				else
					plr = .player;

				Sleep(30000);
			}
		}
	}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);