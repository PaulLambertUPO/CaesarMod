//bool, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(healing))
			if (target != this)
				if (target.AsUnit().IsValid)
					if (target.IsAlive)
						if (target.health < target.maxhealth)
							if (!.IsEnemy(target))
								if (!target.AsUnit().InHolder)
									if (!target.AsShip().IsValid)
										if (!target.IsRam)
											if (.CanSee(target))
												return true;

return false;