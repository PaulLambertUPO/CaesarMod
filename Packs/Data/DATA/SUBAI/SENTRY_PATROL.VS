// void, Obj me, Obj wall1

Unit this, u;
Building wall;
point route0, route1, dirpt, dirpt1;
int state = 4;
int k;
this = me.AsUnit();
wall = wall1.AsBuilding();

// calc the patroling route
{
	point a, b, p, q, d, d1, w;
	int s, k;
	a = wall.GetPoint(2, 0);
	b = wall.GetPoint(2, 1);
	w = wall.GetPoint(17, 0);
	if (w.x != -32768) {
		d = a - w;
		d1 = b - w;
		if (d.x*d.x + d.y*d.y < d1.x*d1.x + d1.y*d1.y) a = w;
		else b = w;
	}
	d = b - a;
	s = d.x*d.x + d.y*d.y;
	p = wall.GetPoint(3, 0);
	q = wall.GetPoint(3, 1);

	d1 = p - a;
	k = (100*(d.x*d1.x + d.y*d1.y))/s;
	route0 = wall.pos + a + ((b - a)*k)/100;

	d1 = q - a;
	k = (100*(d.x*d1.x + d.y*d1.y))/s;
	route1 = wall.pos + a + ((b - a)*k)/100;

	d = .pos - route0;
	d1 = .pos - route1;
	s = d.x*d.x + d.y*d.y;
	k = d1.x*d1.x + d1.y*d1.y;
	if (k < s) state = 2;
}


// for debug
//Place("Feedback", route0, .player);
//Place("Feedback", route1, .player);

dirpt = wall.GetPoint(8, 0);

while (!.Stop(1000));

while(1) {
	if (state == 2) {
		while (!.Goto((route1*4 + route0)/5, 0, 2000, true, 0));
		state = 4;
	} else if (state == 4) {
		while (!.Goto((route0*4 + route1)/5, 0, 2000, true, 0));
		state = 2;
	}

	.Face(.pos - dirpt);
	dirpt1 = dirpt;
	k = rand(13)+2;
	while (k > 0) {
		Sleep(rand(200) + 100);
		dirpt1 = dirpt1 + Point(rand(81)-40, rand(81)-40);
		.Face(.pos - dirpt1);
		k = k - 1;
	}
}

