//void, Obj This, Obj bld

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building building;

		building = bld.AsBuilding();

		if (building.IsValid)
			if (!.IsEnemy(building))
				if (building.IsHeirOf("BaseShipyard")) {
					Settlement set;

					set = building.settlement;

					if (set.IsValid) {
						point pt_dummy;
						Obj o_dummy;

						.SetEntering(true);

						if (!set.Units.Contains(this)) {//this should always happen
							point pt;

							pt = building.GetEnterPoint(this);

							while (!.GotoEnter(pt, 0, 1000, true, 5000))
								if (.IsEnemy(building))
									return;
						}

						.ExecCmd("detach", pt_dummy, o_dummy, false);
						EnvWriteInt(set, "Fishermen", EnvReadInt(set, "Fishermen") + 1);
						.Erase();
					}
				}
	}