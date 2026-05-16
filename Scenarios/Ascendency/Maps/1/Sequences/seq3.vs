ObjList defenders;
IntArray houses;
Obj this, o;
point pt_pos, pt_1, pt_2;
rect rc;
int i, j, k, plr, rng, conquered_houses;

rc = GetMapRect();

while (conquered_houses < 32) {
	for (i = 1; i <= 32; i += 1)
		if (houses[i] != 1) {
			this = GetNamedObj("House" + i).obj;
			pt_pos = .pos;
			plr = .player;
			rng = .range;
			if (plr != 13) {
				houses[i] = 1;
				conquered_houses += 1;
			}
			else {
				defenders = Group("DefH" + i).GetObjList();
				defenders.ClearDead();
				if (defenders.count > 0)
					if (Union(
						Intersect(
							VisibleObjsInSight(this, "Military,BaseMage"),
							Subtract(
								Intersect(
									ObjsInRange(this, "Unit", rng),
									Union(EnemyObjs(plr, "Military"), EnemyObjs(plr, "BaseMage"))
								),
								EnemyObjs(plr, "Sentry")
							)
						),
						Intersect(ObjsInRange(this, "Catapult", rng), EnemyObjs(plr, "Catapult"))
					).IsEmpty)
						defenders.SetCommand("guard_enter", this);
					else
						for (j = defenders.count - 1; j >= 0; j -= 1) {
							o = defenders[j];
							if (o.IsAlive) {
								if (o.AsUnit().InHolder) {
									pt_1.Set(0, rng / 2);
									pt_1.Rot(rand(360));
									pt_2 = pt_1 + pt_pos;
									pt_2.IntoRect(rc);
									o.SetCommand("guard_advance", pt_2);
								}
								else if (.DistTo(o) > rng) {
									pt_1 = o.pos - pt_pos;
									pt_1.SetLen(rng / 2);
									pt_2 = pt_1 + pt_pos;
									pt_2.IntoRect(rc);
									o.SetCommand("move", pt_2);
								}
								for (k = 0; k < 4; k += 1) {
									pt_1.Rot(90);
									pt_2 = pt_1 + pt_pos;
									pt_2.IntoRect(rc);
									o.AddCommand(false, "guard_patrol", pt_2);
								}
							}
						}
			}
		}
	Sleep(1000);
}