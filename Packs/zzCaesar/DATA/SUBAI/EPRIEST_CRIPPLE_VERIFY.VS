//bool, Obj This, Obj target

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(cripple))
			if (target != this)
				if (target.IsAlive)
					if (.IsEnemy(target))
						if (target.stamina > 0)
							if (!target.IsRam)
								if (!target.AsHero().IsValid)
									if (!target.AsUnit().InHolder)
										if (.CanSee(target))
											return true;

return false;