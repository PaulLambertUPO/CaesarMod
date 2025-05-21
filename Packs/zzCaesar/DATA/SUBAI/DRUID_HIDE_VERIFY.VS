//bool, Obj This, Obj target

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(invisibility))
			if (target.IsAlive)
				if (!.IsEnemy(target))
					if (!target.IsSentry)
						if (target.IsVisible)
							if (!target.AsUnit().InHolder)
								if (.CanSee(target))
									return true;

return false;