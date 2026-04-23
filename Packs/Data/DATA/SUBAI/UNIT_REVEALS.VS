//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

ObjList h_army;
Obj o;
int i, j;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsAlive) {
		if (!o.IsVisible) {
			if (o.AsUnit().HasSpecial(sneak))
				o.AsUnit().SetLastAttackTime();
			o.SetVisible(true);
		}
		if (o.AsHero().IsValid) {
			h_army = o.AsHero().army;
			for (j = h_army.count - 1; j >= 0; j -= 1) {
				o = h_army[j];
				if (o.IsAlive)
					if (!o.IsVisible) {
						if (o.AsUnit().HasSpecial(sneak))
							o.AsUnit().SetLastAttackTime();
						o.SetVisible(true);
					}
			}
		}
	}
}