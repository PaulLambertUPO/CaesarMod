//bool, Obj This, Obj target

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (target != this)
			if (target.AsUnit().IsValid)
				if (target.IsAlive)
					if (!target.AsUnit().InHolder)
						if (.CanSee(target))
							return true;

return false;