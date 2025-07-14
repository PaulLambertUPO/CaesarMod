//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Unit u;
int i;

for (i = 0; i < objs.count; i += 1) {
	u = objs[i].AsUnit();
	if (u.IsValid)
		if (u.InHolder)
			u.SneakCommand("convert");
}