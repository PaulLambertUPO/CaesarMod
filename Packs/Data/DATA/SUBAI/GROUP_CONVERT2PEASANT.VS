//void, ObjList objs,point pt, Obj obj, bool bReplace, bool bModifier, int player

Unit u, v;
int i;
point p;

p.Set(-1,-1);

for (i = objs.count - 1; i >= 0; i -= 1) {
	u = objs[i].AsUnit;
	if (u.IsValid) {
		v = Place("IVillager", u.pos, u.player);
		if (u.InHolder()) {
			v.EnterHolder(u);
			u.ExitHolder(p);
		}
		u.Erase();
	}
}
