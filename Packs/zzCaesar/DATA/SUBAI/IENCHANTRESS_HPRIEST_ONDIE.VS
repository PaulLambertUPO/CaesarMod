//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (!.InHolder) {
		//this is to avoid damaging units with trample and constantly creating useless visual effects
		.SetSpecial(revenge, false);
		.SetSpecial(spike_armor, false);
		.SetSpecial(defense_skill, false);
		.SetSpecial(defensive_tactics, false);
		.SetSpecial(deflection, false);
		.SetSpecial(determination, false);

		.SetNoAIFlag(true);

		if (IsResearched(.player, "Restoration")) {
			ObjList ol;
			Obj o;
			int i, restored_units;

			ol = ObjsInCircle(.pos, .sight, "Unit").GetObjList();

			for (i = ol.count - 1; i >= 0; i -= 1) {
				o = ol[i];
				if (o.IsAlive)
					if (o.stamina < o.maxstamina)
						if (!.IsEnemy(o)) {
							o.SetStamina(o.maxstamina);
							CreateFeedback("StaminaBoost", o.AsUnit());
							restored_units += 1;
							if (restored_units >= 5)
								break;
						}
			}
		}
	}