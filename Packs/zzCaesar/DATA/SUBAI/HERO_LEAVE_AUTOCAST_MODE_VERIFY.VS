//bool, ObjList objs, str OUT reasonText

Obj o;
int i;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsAlive)
		if (o.AsHero().autocast)
			return true;
}

return false;