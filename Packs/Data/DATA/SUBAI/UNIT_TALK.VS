//void, Obj This, Obj other

if (other.AsUnit().IsValid) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive)
			if (other != this)
				if (other.IsAlive) {
					while (!.Goto(other, 20, 2000, false, 0))
						if (other.IsDead)
							break;
					if (other.IsAlive) {
						.Face(other.posRH);
						.Idle(2000 + rand(1001));
					}
				}
}

Sleep(15);//prevent possible loops with other commands