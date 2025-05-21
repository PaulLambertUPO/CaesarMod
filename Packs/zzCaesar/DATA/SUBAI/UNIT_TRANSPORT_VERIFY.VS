//bool, Obj this, Obj other

if (other.class == "Inn")
	if (GetInnState(other) == 1)
		if (.AsUnit().GetParty())
			return true;

return false;