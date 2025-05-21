// void, Obj me, Obj target1

Unit this;
point target_pt, pt, pt1, pt2;
int npt, k, best_radius, radius, dx, dy, dist1, dist2;
Building target;
int range;

this = me.AsUnit();
target = target1.AsBuilding();
if (!.IsAlive() || !target.IsAlive())
	return;

range = .radius + 10;
if (target.IsHeirOf("Gate")) {
	pt1 = target.GetPoint(17, 0);
	pt2 = target.GetPoint(17, 1);
	if (pt1.x != -32768 || pt2.x != -32768) {
		dist1 = -1;
		dist2 = -1;
		if (pt2.x != -32768) {
			pt2 = pt2 + target.pos;
			dist2 = .PathTo(pt2, 0, 0);
			target_pt = pt2;
		}
		if (pt1.x != -32768) {
			pt1 = pt1 + target.pos;
			dist1 = .PathTo(pt1, 0, 0);
			target_pt = pt1;
		}
		if (dist1 >= 0) {
			if (dist2 >= 0) {
				if (dist2 < dist1) target_pt = pt2;
				else target_pt = pt1;
			} else target_pt = pt1;
			range = 0;
		} else if (dist2 >= 0) {
			target_pt = pt2 + target.pos;
			range = 0;
		}
	} else {
		npt = 0;
		pt = target.GetPoint(10, 0);
		if (pt.x != -32768) {
			npt = 1;
			target_pt = pt + target.pos;
		}
		pt = target.GetPoint(10, 1);
		if (pt.x != -32768) {
			npt += 1;
			target_pt = target_pt + pt + target.pos;
		}
		pt = target.GetPoint(10, 2);
		if (pt.x != -32768) {
			npt += 1;
			target_pt = target_pt + pt + target.pos;
		}
		if (npt == 0) {
			//pr("Gate " + .class + " has no points of type etDestLock2!!");
			return;
		}
		target_pt = target_pt / npt;
//		pr ("target pt = " + target_pt.x + "," + target_pt.y);
	}
} 


else if (target.settlement.IsOutpost() || target.settlement.IsShipyard()) {
	best_radius = 100000000;
	k = 0;
	while (1) {
		pt = target.GetPoint(17, k);
		k += 1;
		if (pt.x == -32768) break;
		pt = pt + target.pos;
		dx = pt.x - .pos.x;
		dy = pt.y - .pos.y;
		radius = dx*dx + dy*dy;
		if (radius >= best_radius) continue;
		best_radius = radius;
		target_pt = pt;
		range = 0;
	}

	if (k == 1) {
		k = 0;
		while (1) {
			pt = target.GetPoint(1, k);
			k += 1;
			if (pt.x == -32768) break;
			pt = pt + target.pos;
			dx = pt.x - .pos.x;
			dy = pt.y - .pos.y;
			radius = dx*dx + dy*dy;
			if (radius >= best_radius) continue;
			best_radius = radius;
			target_pt = pt;
		}
		if (k == 1) {
			//pr ("outpost/shipyard has no enter points!");
			return;
		}
	}
}


else {
	//pr ("invalid ram target");
	return;
}


//Place("Feedback", target_pt, .player);

while (1) {
	if (.GotoEnter(target_pt, range, 2000, false, 0)) break;
}

while (1) {
	if (!.CanAttack(target)) break;
	if (target.health == 0) break;
	.Attack(target);
}


