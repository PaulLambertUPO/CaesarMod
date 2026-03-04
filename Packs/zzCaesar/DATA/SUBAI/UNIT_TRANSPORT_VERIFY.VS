//bool, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (other.IsHeirOf("Inn"))
			if (GetInnState(other) == 1)
				if (.GetParty())
					return true;

return false;