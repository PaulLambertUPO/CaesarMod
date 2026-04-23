//bool, ObjList objs, str OUT reasonText

ObjList h_army;
Obj o;
int i, j, max_train_level;

o = objs[0];
if (o.IsValid)
	max_train_level = EnvReadInt(o.player, "maxtrainlevel");

reasonText = rollover() + "\n<color 255 255 255>" + Translatef("Maximum training level: %s1", max_train_level);

if (max_train_level > 0)
	for (i = objs.count - 1; i >= 0; i -= 1) {
		o = objs[i];
		if (o.IsAlive) {
			if (o.AsUnit().inherentlevel < max_train_level)
				return true;
			if (o.AsHero().IsValid) {
				h_army = o.AsHero().army;
				for (j = h_army.count - 1; j >= 0; j -= 1) {
					o = h_army[j];
					if (o.IsAlive)
						if (o.AsUnit().inherentlevel < max_train_level)
							return true;
				}
			}
		}
	}

reasonText = reasonText + "\n<color 255 0 0>" + Translate("Cannot train warriors");

return false;