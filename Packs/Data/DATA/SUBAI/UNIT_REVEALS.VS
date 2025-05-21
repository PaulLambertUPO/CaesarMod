//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

int i,j;
Unit u;

for(i = 0; i < objs.count(); i += 1)
{
	u = objs[i].AsUnit;
	if (u.IsValid)
		if (!u.IsVisible) {
			if(u.IsHeirOf("Hero")) {
				ObjList armies;

				armies=u.AsHero().army;
				u.SetVisible(true);
				u.SetLastAttackTime();
				for(j = 0; j < armies.count(); j += 1)
				{
					Unit w;

					w=armies[j].AsUnit();
					w.SetVisible(true);
					w.SetLastAttackTime();
				}
			}
			else {
				u.SetVisible(true);
				u.SetLastAttackTime();
			}
		}
}