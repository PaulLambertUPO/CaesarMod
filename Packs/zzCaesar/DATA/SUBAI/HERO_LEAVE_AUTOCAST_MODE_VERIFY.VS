//bool, ObjList objs, str OUT reasonText

Hero h;
int i;

for (i = 0; i < objs.count; i += 1) {
	h = objs[i].AsUnit();
	if (h.IsValid)
		if (h.autocast)
			return true;
}

return false;