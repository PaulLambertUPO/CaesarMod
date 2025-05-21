//void, Obj This

Building bld;
Settlement this;

bld = This.AsBuilding();
if (bld.IsValid) {
	this = bld.settlement;
	if (.IsValid) {
		ObjList l;
		int i;
		Unit u;

		l = .ObjectsAround("Military");
		l.AddList(.ObjectsAround("BaseMage"));
		for (i = l.count; i > 0;) {
			i -= 1;
			u = l[i].AsUnit();
			if (bld.IsEnemy(u))
				continue;
			if (u.inherentlevel >= 10)
				continue;
			u.SetLevel(u.inherentlevel + 1);
			CreateFeedback("Experience", u);
		}	
		bld.PlaySound("Data/Sound Entities/TownhallMilitaryTraining.xml");
	}
}