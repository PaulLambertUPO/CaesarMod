// void, Obj This, Obj target

Building this;
ObjList blds;
Settlement sett;
int i;

this = This.AsBuilding();

if (!.IsValid)
	return;
if (.settlement.IsIndependent())
	return;
if (.IsValid() && target.IsValid()) {
	sett = .settlement();
	blds = sett.Buildings;
	for (i = 0; i < blds.count(); i += 1) {
		Tower t;
		t = blds[i].AsTower();
		if (t.IsValid()) {
			if (t.IsHeirOf("FakeTower")) 
				t.SetCommand("attack",target);
		}
	}
}
