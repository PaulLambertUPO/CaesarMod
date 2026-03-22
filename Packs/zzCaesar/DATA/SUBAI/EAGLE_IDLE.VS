//void, Obj This

Flying this;

this = This.AsFlying();

if (.IsValid)
	if (.IsAlive) {
		point pt_fly;

		pt_fly = .posRH;

		pt_fly.Set(pt_fly.x - 1500, pt_fly.y - 1500);

		pt_fly = pt_fly.ClampToMap();

		pt_fly.Set(pt_fly.x + 3000, pt_fly.y + 3000);

		pt_fly = pt_fly.ClampToMap();

		pt_fly.Set(pt_fly.x - 500 - rand(2001), pt_fly.y - 500 - rand(2001));

		.AddCommand(true, "move", .ClipDestToMap(pt_fly));
	}