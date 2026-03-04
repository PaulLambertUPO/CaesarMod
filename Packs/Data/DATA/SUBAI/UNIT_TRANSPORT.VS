//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (other.IsHeirOf("Inn")) {
			while (!.Goto(other, other.sight / 3, 2500, false, 0))
				;
			other.SetCommand("transport_request");
		}