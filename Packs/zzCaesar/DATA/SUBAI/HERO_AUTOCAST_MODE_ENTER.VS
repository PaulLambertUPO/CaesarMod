//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Obj o;
int i;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsAlive)
		o.AsHero().SetAutocast(true);
}