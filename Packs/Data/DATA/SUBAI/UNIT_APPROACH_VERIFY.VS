//bool, Obj this, Obj other

if (other.IsAlive)
	if (.AsUnit().IsValid)
		if (.IsAlive)
			if (other != this) {
				if (!other.AsUnit().IsValid)
					return true;
				if (!other.AsUnit().InHolder)
					if (.CanSee(other))
						return true;
			}

return false;