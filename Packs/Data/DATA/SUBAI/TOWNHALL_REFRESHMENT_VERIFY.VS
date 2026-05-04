//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;
ObjList ol;
Obj o;
int i;

this = objs[0].AsBuilding();
set = .settlement;

ol = set.ObjectsAround("Military");
ol.AddList(set.ObjectsAround("BaseMage"));

for (i = ol.count - 1; i >= 0; i -= 1) {
	o = ol[i];
	if (o.IsAlive)
		if (o.stamina < o.maxstamina)
			if (!.IsEnemy(o)) {
				reasonText = rollover(this, true);
				return true;
			}
}

reasonText = rollover() + "\n<color 255 0 0>" + Translate("There are no allies to revitalize around the settlement");

return false;