//void, Obj This, Obj bld

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building building;

		building = bld.AsBuilding();

		if (building.IsValid)
			if (building.IsCentralBuliding)
				if (!.IsEnemy(building))
					if (!building.IsHeirOf("BaseRuins")) 
						if (!building.IsHeirOf("Catapult")) {
							Settlement set;

							set = building.settlement;

							if (set.IsValid) {
								.SetEntering(true);

								if (!set.Units.Contains(this)) {
									point pt;

									pt = building.GetEnterPoint(this);

									while (!.GotoEnter(pt, 0, 1000, true, 5000))
										if (.IsEnemy(building))
											return;

									if (set.max_population > 0) {
										point pt_dummy;
										Obj o_dummy;

										.ExecCmd("detach", pt_dummy, o_dummy, false);
										set.AddToPopulation(1);
										.Erase();
									}
									else if (set.max_units > 0)
										set.AddUnit(this);
								}
								else if (set.max_population > 0) {
									point pt_dummy;
									Obj o_dummy;

									.ExecCmd("detach", pt_dummy, o_dummy, false);
									set.AddToPopulation(1);
									.Erase();
								}
							}
						}
	}