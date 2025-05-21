Building this;
Query enemies;
ObjList defenders;
IntArray houses;
Unit u;
point pos, pt1, pt2;
rect rc;
int i, j, k, range, player, conquered_houses;

rc = GetMapRect();

while (conquered_houses < 32) {
	for (i = 1; i <= 32; i += 1)
		if (houses[i] != 1) {
			this = GetNamedObj("House" + i).obj.AsBuilding();
			range = .range;
			player = .player;
			pos = .pos;
			if (player != 13) {
				houses[i] = 1;
				conquered_houses += 1;
			}
			else {
				defenders = Group("DefH" + i).GetObjList();
				defenders.ClearDead();
				if (defenders.count > 0) {
					enemies = Union(
						Intersect(
							VisibleObjsInSight(this, "Unit"),
							Subtract(
								Intersect(
									ObjsInRange(this, "Unit", range),
									Union(EnemyObjs(player, "Military"), EnemyObjs(player, "BaseMage"))
								),
								EnemyObjs(player, "Sentry")
							)
						),
						Intersect(ObjsInRange(this, "Building", range), EnemyObjs(player, "Catapult"))
					);
					if (enemies.IsEmpty())
						defenders.SetCommand("enter_tent", this);
					else
						for (j = 0; j < defenders.count; j += 1) {
							u = defenders[j].AsUnit();
							if (u.InHolder) {
								pt1.Set(0, range / 2);
								pt1.Rot(rand(360));
								pt2 = pt1 + pos;
								pt2.IntoRect(rc);
								u.SetCommand("guardadvance", pt2);
							}
							else if (.DistTo(u) > range) {
								pt1 = u.pos - pos;
								pt1.SetLen(range / 2);
								pt2 = pt1 + pos;
								pt2.IntoRect(rc);
								u.SetCommand("move", pt2);
							}
							for (k = 0; k < 4; k += 1) {
								pt1.Rot(90);
								pt2 = pt1 + pos;
								pt2.IntoRect(rc);
								u.AddCommand(false, "guardpatrol", pt2);
							}
						}
				}
			}
		}
	Sleep(1000);
}