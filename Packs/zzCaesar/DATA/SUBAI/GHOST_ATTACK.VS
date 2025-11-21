//void, Obj me, Obj tgt

Unit this;

this = me.AsGhost();

if (.IsValid) {
	Unit u;

	if (.GetAnim() == 17)//spawn
		Sleep(.TimeToAnimFinish);

	u = tgt.AsUnit();

	if (u.IsValid)
		while (!.Goto(u, .range - 20, 3000, false, 0)) {
			if (!.HasPath())
				break;
			if (u.IsDead)
				break;
			if (!.IsEnemy(u))
				break;
			if (u.InHolder)
				break;
		}
}