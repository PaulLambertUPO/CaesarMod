//bool, ObjList objs, str OUT reasonText

int i;

for (i = 0; i < objs.count; i += 1)
	if (!objs[i].IsVisible)
		return true;

return false;