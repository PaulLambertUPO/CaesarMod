//void, Obj This, Obj target

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		while (.IsValidTarget(target)) {
			if (!.InRange(target))
				break;
			.Attack(target);
		}