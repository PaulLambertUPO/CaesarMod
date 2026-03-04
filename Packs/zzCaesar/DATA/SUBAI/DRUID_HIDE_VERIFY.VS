//bool, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(invisibility))
			if (target.AsUnit().IsValid)
				if (target.IsAlive)
					if (target.IsVisible)
						if (!.IsEnemy(target))
							if (!target.AsUnit().InHolder)
								if (!target.IsWaterUnit)
									if (!target.IsSentry)
										if (!target.IsPeasantAmbient)
											if (!target.IsRam)
												if (.CanSee(target))
													return true;

return false;