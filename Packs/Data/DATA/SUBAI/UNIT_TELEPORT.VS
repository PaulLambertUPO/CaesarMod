//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Teleport telep_enter;

		telep_enter = other.AsTeleport();

		if (telep_enter.IsValid) {
			Teleport telep_exit;
			point pt_exit;

			telep_exit = telep_enter.destination;

			pt_exit = telep_exit.exit_vector;
			pt_exit.SetLen(telep_exit.radius + pt_exit.Len * (20 + rand(81)) / 100);
			pt_exit.Rot(60 - rand(121));
			pt_exit = pt_exit + telep_exit.pos;
			pt_exit = pt_exit.ClampToMap();

			if (!telep_enter.settlement.Units.Contains(this)) {
				point pt_enter;

				pt_enter = telep_enter.GetEnterPoint(this);

				.SetEntering(true);

				while (!.GotoEnter(pt_enter, 0, 1000, false, 2500))
					;
			}

			telep_enter.Traverse(.player);
			telep_exit.Traverse(.player);

			telep_exit.settlement.ForceAddUnit(this);

			.AddCommand(true, "advance", pt_exit);
		}
	}

Sleep(15);//prevent possible loops with other commands