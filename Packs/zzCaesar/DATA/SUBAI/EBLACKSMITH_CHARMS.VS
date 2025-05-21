//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	Settlement set;

	EnvWriteString(this, "researching", "yes");

	.Progress();

	EnvWriteString(this, "researching", "no");

	set = .settlement;

	if (set.IsValid) {
		ObjList l;
		Unit u;
		int i, count_units;

		l = set.ObjectsAround("Military");
		l.ClearDead();
		for (i = 0; i < l.count && count_units < 65; i += 1) {
			u = l[i].AsUnit();
			if (u.IsValid)
				if (!.IsEnemy(u))
					if (!u.HasItem(cmdparam))
						if (!u.IsSentry)
							if (!u.IsHeirOf("Hero")) {
								u.AddItem(cmdparam);
								count_units += 1;
							}
		}
	}
}