//void, Obj This

Settlement this;
ObjList warriors;
int j;

this = This.AsBuilding().settlement;

warriors = .Units.ObjClass("Military");

j = warriors.count - 1;

if (j >= 0) {
	ObjList heroes;
	Hero h;
	Obj o;
	int i, plr, attachable_warriors;

	plr = .player;

	heroes = warriors.ObjClass("Hero");

	for (i = heroes.count - 1; i >= 0; i -= 1) {
		h = heroes[i].AsHero();
		if (h.IsAlive)
			if (h.player == plr) {
				attachable_warriors = h.maxarmy - h.army.count;
				while (attachable_warriors > 0) {
					o = warriors[j];
					if (o.IsAlive)
						if (o.player == plr)
							if (!o.AsHero().IsValid)
								if (!o.AsUnit().HasFreedom)
									if (o.AsUnit().hero.IsDead) {
										o.SetCommand("attach", h);
										attachable_warriors -= 1;
									}
					j -= 1;
					if (j < 0)
						return;
				}
			}
	}
}