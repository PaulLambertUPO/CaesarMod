//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid) {
	//this is to avoid damaging units with trample and constantly creating useless visual effects
	.SetSpecial(revenge, false);
	.SetSpecial(spike_armor, false);
	.SetSpecial(defense_skill, false);
	.SetSpecial(defensive_tactics, false);
	.SetSpecial(deflection, false);
	.SetSpecial(determination, false);

	.SetNoAIFlag(true);

	if (!.InHolder()) {
		Unit u;
		ObjList ol;
		int i, race;

		race = .race;

		if (race == RepublicanRome) {
			if (IsResearched(.player, "Wrath of Jupiter")) {
				u = .GetJupiterAngerTarget();
				if (u.IsValid)
					if (u.IsAlive) {
						//do not kill to avoid the "resurrection bug" that occurs when a unit is healed upon dying (triumph, life steal, statue of Zeus, amulet of triumph...)
						if (u.AsHero())
							u.Damage(MIN(40, u.health - 1));
						else
							u.Damage(MIN(250, u.health - 1));
						CreateFeedback("Lightning3", u);
					}
			}
		}
		else if (race == Carthage || race == Egypt) {
			if (IsResearched(.player, "Zombify"))
				if (!.IsSummoningDeath()) {
					Unit u;
					u = Place("GGhost", .pos, .player);
					u.SetStamina(5);
					u.SetLevel(.inherentlevel);
					u.SetCommand("spawn");
					SwapSelectedObj(this, u);
				}
		}
		else if (race == Germany || race == Britain) {
			if (IsResearched(.player, "Mass Heal")) {
				int health_to_distribute = 1000, give;

				ol = ObjsInCircle(.pos, .sight, "Unit").GetObjList();

				for (i = 0; i < ol.count && health_to_distribute > 0; i += 1) {
					u = ol[i].AsUnit();
					if (u.IsValid)
						if (!.IsEnemy(u))
							if (u.health < u.maxhealth) {
								give = MIN(health_to_distribute, u.maxhealth - u.health);
								health_to_distribute -= give;
								u.Heal(give);
								CreateFeedback("Heal", u);
							}
				}
			}
		}
		else if (race == Gaul || race == ImperialRome || race == Iberia) {
			if (IsResearched(.player, "Restoration")) {
				int nRestored;

				ol = ObjsInCircle(.pos, .sight, "Unit").GetObjList();

				for (i = 0; i < ol.count && nRestored < 5; i += 1) {
					u = ol[i].AsUnit();
					if (u.IsValid)
						if (!.IsEnemy(u))
							if (u.stamina < u.maxstamina) {
								u.SetStamina(u.maxstamina);
								CreateFeedback("StaminaBoost", u);
								nRestored += 1;
							}
				}
			}
			if (race == Gaul)
				if (IsResearched(.player, "Reincarnation Ritual"))
					if (!.IsSummoningDeath()) {
						if (rand(2) == 0)
							u = Place("BearSummoned", .pos, .player);
						else
							u = Place("BoarSummoned", .pos, .player);
						u.SetStamina(u.maxstamina);
						u.SetLevel(.inherentlevel);
						u.SetNoAIFlag(true);
						SwapSelectedObj(this, u);
					}
		}
	}
}