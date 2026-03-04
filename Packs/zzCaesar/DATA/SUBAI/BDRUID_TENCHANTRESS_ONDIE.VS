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

		if (IsResearched(.player, "Mass Heal")) {
			ObjList ol;
			Obj o;
			int i, health_given, health_to_distribute = 1000;

			ol = ObjsInCircle(.pos, .sight, "Unit").GetObjList();

			for (i = ol.count - 1; i >= 0; i -= 1) {
				o = ol[i];
				if (o.IsAlive)
					if (o.health < o.maxhealth)
						if (!.IsEnemy(o)) {
							health_given = MIN(health_to_distribute, o.maxhealth - o.health);
							health_to_distribute -= health_given;
							o.Heal(health_given);
							CreateFeedback("Heal", o.AsUnit());
							if (health_to_distribute <= 0)
								break;
						}
			}
		}
	}