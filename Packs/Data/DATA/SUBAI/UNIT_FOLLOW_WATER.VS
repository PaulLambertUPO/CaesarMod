//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (other != this) {
			Unit followed_unit;

			followed_unit = other.AsUnit();

			if (followed_unit.IsValid)
				if (followed_unit.IsWaterUnit) {
					if (.AI)
						.SetParryMode(false);

					while (followed_unit.IsAlive) {
						if (.IsEnemy(followed_unit))
							break;
						if (!.CanSee(followed_unit))
							break;
						if (.Goto(followed_unit, 70, 1000, false, -1))
							Sleep(1500);
					}
				}
		}

Sleep(30);//prevent possible loops with other commands