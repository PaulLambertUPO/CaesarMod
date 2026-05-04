//void, Obj This, Obj other

if (other.AsUnit().IsValid) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive)
			if (other != this)
				if (other.IsAlive) {
					if (.AI)
						.SetParryMode(false);

					.SetEntering(true);

					while (other.IsAlive)
						if (.GotoEnter(other.pos, 80, 2000, false, 0)) {
							if (other.IsAlive) {
								.Face(other.pos);
								.Idle(2000 + rand(1001));
							}
							break;
						}
				}
}

Sleep(30);//prevent possible loops with other commands