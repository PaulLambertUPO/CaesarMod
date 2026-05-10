//void, Obj This, Obj other

if (other.IsValid)
	if (other.IsHeirOf("Inn")) {
		Hero this;

		this = This.AsHero();

		if (.IsValid)
			if (.IsAlive) {
				if (other.DistTo(.posRH) >= 300) {
					.FormSetupAndMoveTo(other.pos, 0, 0, true);
					while (.HasPath) {
						if (.DistTo(other) < 300)
							break;
						.FormKeepMoving(1000);
					}
				}
				other.SetCommand("transport_request");
			}
	}

Sleep(30);//prevent possible loops with other commands