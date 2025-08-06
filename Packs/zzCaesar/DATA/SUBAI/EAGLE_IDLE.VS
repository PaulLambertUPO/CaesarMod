//void, Obj This

Flying this;

this = This.AsFlying();

if (.IsValid) {
	point pt_fly;

	pt_fly = .pos;

	pt_fly.Set(pt_fly.x - 1500, pt_fly.y - 1500);

	pt_fly = pt_fly.ClampToMap();

	pt_fly.Set(pt_fly.x + 3000, pt_fly.y + 3000);

	pt_fly = pt_fly.ClampToMap();

	pt_fly.Set(pt_fly.x - 1500, pt_fly.y - 1500);

	.AddCommand(true, "move", .ClipDestToMap(Point(pt_fly.x + 1000 - rand(2001), pt_fly.y + 1000 - rand(2001))));
}