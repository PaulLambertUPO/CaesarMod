//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;
ObjList ol;
Unit u;
int i;

this = objs[0].AsBuilding();
set = .settlement;

ol = set.ObjectsAround("Military");
ol.AddList(set.ObjectsAround("BaseMage"));

for (i = ol.count - 1; i >= 0; i -= 1) {
	u = ol[i].AsUnit();
	if (u.IsAlive)
		if (u.inherentlevel < 10)
			if (!.IsEnemy(u)) {
				reasonText = rollover(this, true);
				return true;
			}
}

reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("There are no allies to train around the settlement");

return false;