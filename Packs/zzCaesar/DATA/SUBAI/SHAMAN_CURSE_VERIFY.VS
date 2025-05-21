//bool, Obj This, Obj target

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(curse))
			if (target != this)
				if (target.IsAlive)
					if (.IsEnemy(target))
						if (!target.AsUnit().IsCursed)
							if (!target.AsUnit().InHolder)
								if (.CanSee(target))
									return true;

return false;