//void, Obj This

Sleep(1000 + rand(1001));

if (GetConst("NoSentries") == 0)
	if (This.AsBuilding().IsValid) {
		Settlement this;

		this = This.AsBuilding().settlement;

		{
			Settlement invalid;
			ObjList ol;
			Obj o;
			int i;
			bool no_sentries = true;

			ol = .Buildings;

			for (i = ol.count - 1; i >= 0; i -= 1) {
				o = ol[i];
				if (o.IsGate) {
					no_sentries = false;
					break;
				}
				if (o.IsHeirOf("Wall")) {
					no_sentries = false;
					break;
				}
			}

			if (no_sentries)
				this = invalid;
		}

		if (.IsValid) {
			while (.IsIndependent)
				Sleep(5000);

			{
				int plr, missing_sentries;

				.AddMaxSentries(20);//total max = 20 + 1 per wall + 4 per gate (total max is usually 50-52)

				while (true) {
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
	}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);