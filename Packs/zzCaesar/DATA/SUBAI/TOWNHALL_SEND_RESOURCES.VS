//void, Obj This

Settlement this;
int g, f;

this = This.AsBuilding().settlement;

g = MIN(.gold, 1000);
f = MIN(.food, 1000);

if (g > 0 || f > 0) {
	ObjList strongholds;
	Settlement set;
	int i, plr;

	plr = .player;

	strongholds = GetSettlements("BaseTownhall", 0);

	for (i = strongholds.count - 1; i >= 0; i -= 1) {
		set = strongholds[i].AsBuilding().settlement;
		if (set.player != plr)
			if (set.IsAlly(plr)) {
				if (g > 0) {
					.SetGold(.gold - g);
					set.SetGold(set.gold + g);
					g = MIN(.gold, 1000);
				}
				if (f > 0) {
					.SetFood(.food - f);
					set.SetFood(set.food + f);
					f = MIN(.food, 1000);
				}
				if (g <= 0)
					if (f <= 0)
						break;
			}
	}

	EnvWriteInt(this, "LastResourceSending", GetTime());
}