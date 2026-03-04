//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (other != this)
			if (other.AsUnit().IsValid)
				if (other.IsAlive) {
					while (!.Stop(1000))
						;
					while (!.Goto(other, 20, 2000, false, 0))
						if (other.IsDead)
							break;
					if (other.IsAlive) {
						.Face(other.posRH);
						.Idle(2000 + rand(1001));
					}
				}