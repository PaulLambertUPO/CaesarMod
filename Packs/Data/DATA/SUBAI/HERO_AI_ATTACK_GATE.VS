//void, Obj h, Obj g

if (g.AsGate().IsValid) {
	Hero this;

	this = h.AsHero();

	if (.IsValid)
		if (.IsAlive) {
			.FormSetupAndMoveTo(g.pos, 0, 0, true);

			while (.HasPath) {
				if (.DistTo(g) < .sight + 100)
					break;
				.FormKeepMoving(1500);
			}

			.army.SetCommand("ai_attack_gate", g);
		}
}

Sleep(15);//prevent possible loops with other commands