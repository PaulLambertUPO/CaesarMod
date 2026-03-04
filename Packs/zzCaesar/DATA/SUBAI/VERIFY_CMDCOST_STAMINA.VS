//bool, ObjList objs, str OUT reasonText

Obj o;
int i, stamina_cost;

stamina_cost = cmdcost_stamina;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsAlive)
		if (o.stamina >= stamina_cost) 
			return true;
}

reasonText = rollover(o, true);

return false;