//void, Obj This, Obj other

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive)
		if (other.IsHeirOf("Inn")) {
			.FormSetupAndMoveTo(other, other.sight / 3, other.radius, true);

			while (.HasPath())
				.FormKeepMoving(1500);

			other.SetCommand("transport_request");
		}