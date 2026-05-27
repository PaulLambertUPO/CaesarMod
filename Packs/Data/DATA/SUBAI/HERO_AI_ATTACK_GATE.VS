//void, Obj h, Obj g

if (g.IsGate) {
	Hero this;

	this = h.AsHero();

	if (.IsValid)
		if (.IsAlive) {
			if (g.DistTo(.posRH) >= 450) {
				.FormSetupAndMoveTo(g.pos, 0, 0, true);
				while (.HasPath) {
					if (.DistTo(g) < 450)
						break;
					.FormKeepMoving(1000);
				}
			}
			.army.SetCommand("ai_attack_gate", g);
		}
}

Sleep(30);//prevent possible loops with other commands