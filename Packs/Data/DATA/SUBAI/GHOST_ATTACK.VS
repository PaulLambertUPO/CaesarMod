//void, Obj me, Obj u

Unit this;

this = me.AsUnit();

if (.GetAnim() == 17)//spawn
	Sleep(.TimeToAnimFinish);

if (u.AsUnit().IsValid)
	while (!.Goto(u, .range - 20, 3000, false, 0)) {
		if (!.HasPath())
			break;
		if (!u.IsAlive)
			break;
	}