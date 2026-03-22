//bool, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (target != this)
			if (target.AsUnit().IsValid)
				if (target.IsAlive)
					if (.experience < target.AsUnit().experience)
						if (!.IsEnemy(target))
							if (!target.AsUnit().InHolder)
								if (!target.IsWaterUnit)
									if (!target.IsRam)
										if (.CanSee(target)) {
											int r;
											r = .race;
											if (r != Gaul)
												if (r != Germany)
													if (r != Britain)
														return true;
											if (IsResearched(.player, "Ritual Chamber"))
												return true;
										}

return false;