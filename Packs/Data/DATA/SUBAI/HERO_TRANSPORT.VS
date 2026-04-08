//void, Obj This, Obj other

if (other.IsValid)
	if (other.IsHeirOf("Inn")) {
		Hero this;

		this = This.AsHero();

		if (.IsValid)
			if (.IsAlive) {
				.FormSetupAndMoveTo(other, 0, 0, true);

				while (.HasPath) {
					if (.DistTo(other) < 300)
						break;
					.FormKeepMoving(1500);
				}

				if (.DistTo(other) < 300)
					other.SetCommand("transport_request");
			}
	}

Sleep(15);//prevent possible loops with other commands