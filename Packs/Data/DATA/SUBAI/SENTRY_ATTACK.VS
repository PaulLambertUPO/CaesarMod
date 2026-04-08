//void, Obj This, Obj target

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		while (.IsValidTarget(target)) {
			if (!.InRange(target))
				break;
			if (!.IsEnemy(target))//for buildings that change player while under fire
				break;
			.Attack(target);
		}

Sleep(15);//prevent possible loops with other commands