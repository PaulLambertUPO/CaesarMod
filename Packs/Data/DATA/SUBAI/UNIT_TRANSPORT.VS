//void, Obj This, Obj other

if (other.IsValid)
	if (other.IsHeirOf("Inn")) {
		Unit this;

		this = This.AsUnit();

		if (.IsValid)
			if (.IsAlive) {
				while (!.Goto(other, 300, 2500, false, 0))
					;
				other.SetCommand("transport_request");
			}
	}

Sleep(15);//prevent possible loops with other commands