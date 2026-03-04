//bool, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(teaching))
			if (target != this)
				if (target.AsUnit().IsValid)
					if (target.IsAlive)
						if (!.IsEnemy(target))
							if (!target.AsUnit().InHolder)
								if (!target.IsWaterUnit)
									if (!target.IsPeasantAmbient)
										if (!target.IsRam)
											if (.CanSee(target))
												if (IsResearched(.player, "Ancestral Knowledge")) {
													if (target.AsUnit().inherentlevel < GetConst("TeachingLevel2"))
														return true;
												}
												else if (target.AsUnit().inherentlevel < GetConst("TeachingLevel1"))
													return true;

return false;