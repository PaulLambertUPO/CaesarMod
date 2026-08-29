//bool, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(curse))
			if (target != this)
				if (target.AsUnit().IsValid)
					if (target.IsAlive)
						if (!target.AsUnit().IsCursed)
							if (.IsEnemy(target))
								if (!target.AsUnit().InHolder)
									if (!target.AsShip().IsValid)
										if (.CanSee(target))
											return true;

return false;