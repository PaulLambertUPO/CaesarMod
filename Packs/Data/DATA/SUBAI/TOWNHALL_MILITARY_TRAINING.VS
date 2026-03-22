//void, Obj this

Settlement set;
ObjList ol;
Unit u;
int i;

set = .AsBuilding().settlement;

ol = set.ObjectsAround("Military");
ol.AddList(set.ObjectsAround("BaseMage"));

for (i = ol.count - 1; i >= 0; i -= 1) {
	u = ol[i].AsUnit();
	if (u.IsAlive)
		if (u.inherentlevel < 10)
			if (!.IsEnemy(u)) {
				u.SetLevel(u.inherentlevel + 1);
				CreateFeedback("Experience", u);
			}
}

.PlaySound("Data/Sound Entities/TownhallMilitaryTraining.xml");