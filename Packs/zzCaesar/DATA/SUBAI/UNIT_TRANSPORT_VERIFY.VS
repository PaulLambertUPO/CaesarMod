//bool, Obj This, Obj other

if (other.IsValid)
	if (other.IsHeirOf("Inn"))
		if (GetInnState(other) == 1) {
			Unit this;

			this = This.AsUnit();

			if (.IsValid)
				if (.IsAlive)
					if (.GetParty())
						return true;
		}

return false;