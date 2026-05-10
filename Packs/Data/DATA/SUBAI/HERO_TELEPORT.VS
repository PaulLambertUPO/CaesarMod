//void, Obj This, Obj other

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Teleport telep_enter;

		telep_enter = other.AsTeleport();

		if (telep_enter.IsValid) {
			Teleport telep_exit;
			Settlement set_enter, set_exit;
			point pt_exit;

			telep_exit = telep_enter.destination;

			set_enter = telep_enter.settlement;
			set_exit = telep_exit.settlement;

			pt_exit = telep_exit.exit_vector;
			pt_exit.SetLen(telep_exit.radius + pt_exit.Len * (20 + rand(81)) / 100);
			pt_exit.Rot(60 - rand(121));
			pt_exit = pt_exit + telep_exit.pos;
			pt_exit = pt_exit.ClampToMap();

			if (!set_enter.Units.Contains(this)) {
				point pt_enter;

				pt_enter = telep_enter.GetEnterPoint(this);

				if (telep_enter.DistTo(.posRH) >= 400) {
					.FormSetupAndMoveTo(pt_enter, 0, 0, false);
					while (.HasPath) {
						if (.DistTo(telep_enter) < 400)
							break;
						.FormKeepMoving(1000);
					}
				}

				.army.SetCommand("enter", telep_enter);

				.SetEntering(true);

				while (!.GotoEnter(pt_enter, 0, 1000, false, 2500))
					;

				set_enter.ForceAddUnit(this);
			}

			if (.HasArmy) {
				ObjList h_army;
				Obj o;
				int i;
				bool wait_army = true;

				while (wait_army) {
					wait_army = false;

					h_army = .army;

					for (i = h_army.count - 1; i >= 0; i -= 1) {
						o = h_army[i];
						if (o.IsAlive)
							if (!(o.AsUnit().GetHolderSett() == set_enter)) {
								wait_army = true;
								o.SetCommand("enter", telep_enter);
							}
					}

					Sleep(500);
				}

				h_army = .army;

				for (i = h_army.count - 1; i >= 0; i -= 1) {
					o = h_army[i];
					if (o.IsAlive)
						set_exit.ForceAddUnit(o.AsUnit());
				}
			}

			telep_enter.Traverse(.player);
			telep_exit.Traverse(.player);

			set_exit.ForceAddUnit(this);

			.AddCommand(true, "advance", pt_exit);
		}
	}

Sleep(30);//prevent possible loops with other commands