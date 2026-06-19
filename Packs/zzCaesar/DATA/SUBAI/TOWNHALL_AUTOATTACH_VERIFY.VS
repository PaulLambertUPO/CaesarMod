//bool, ObjList objs, str OUT reasonText

Obj this, o;
ObjList warriors, heroes;
int i, plr;

this = objs[0];

plr = .player;

warriors = .AsBuilding().settlement.Units.ObjClass("Military");
heroes = warriors.ObjClass("Hero");

for (i = heroes.count - 1; i >= 0; i -= 1) {
	o = heroes[i];
	if (o.IsAlive)
		if (o.player == plr)
			if (!o.AsHero().IsHeroArmyFull) {
				for (i = warriors.count - 1; i >= 0; i -= 1) {
					o = warriors[i];
					if (o.IsAlive)
						if (o.player == plr)
							if (!o.AsHero().IsValid)
								if (!o.AsUnit().HasFreedom)
									if (o.AsUnit().hero.IsDead)
										return true;
				}
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("There are no attachable warriors in the townhall");
				return false;
			}
}

reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("There are no available heroes in the townhall");

return false;