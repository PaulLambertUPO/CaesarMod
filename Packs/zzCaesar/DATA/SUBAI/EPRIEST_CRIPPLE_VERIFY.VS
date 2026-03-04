//bool, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(cripple))
			if (target != this)
				if (target.AsUnit().IsValid)
					if (target.IsAlive)
						if (target.stamina > 0)
							if (.IsEnemy(target))
								if (!target.AsUnit().InHolder)
									if (!target.AsHero().IsValid)
										if (!target.AsShip().IsValid)
											if (!target.IsRam)
												if (.CanSee(target))
													return true;

return false;