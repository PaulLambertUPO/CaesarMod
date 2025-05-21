// void, Obj me, Obj wall_gate

Unit this;
Obj u;
point dirpt, dirpt1;
int k;

this = me.AsUnit();
dirpt = wall_gate.AsBuilding().GetPoint(8, 0);
dirpt1 = dirpt;
k = 0;

while (1) {
	u = .BestTargetInSquadSight();
	while (1) {
		if (!u.IsAlive()) break;
		if (!.IsValidTarget(u)) break;
		if (!.InRange(u)) break;
		.Attack(u);
		dirpt1 = dirpt;
		k = 0;
	}
	.Stop(1000);
	.Face(.pos - dirpt1);
	Sleep(rand(200) + 400);
	if (k < 20) {
		dirpt1 = dirpt1 + Point(rand(51)-25, rand(51)-25);
		k += 1;
	} else {
		dirpt1 = dirpt;
		k = 0;
	}
}
 
