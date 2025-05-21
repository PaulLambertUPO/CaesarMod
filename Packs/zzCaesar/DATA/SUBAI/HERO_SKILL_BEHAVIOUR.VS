//void, Obj This

Hero this;
int skill_to_develop, skill_to_develop_level, available_points, skill_points;
int heal_per_level, rush_damage;
int army_size, fighting_units_perc;
int healing_weight, charge_weight, rush_weight;
int healing_skill_level, charge_skill_level, rush_skill_level;
int healing_skill_amount, healing_max_amount, charge_max_amount, rush_max_amount;

this = This.AsHero();

skill_to_develop = -1;
skill_to_develop_level = -1;

heal_per_level = GetConst("HealthPerHealingLevel");
rush_damage = GetConst("RushDamage");

Sleep(5500 + rand(3) * 100);//the big time is to let the AI manage the skill points when the hero is recruited in specific tactic scripts

while (.IsAlive) {
	if (!.autocast)
		if (!.AI) {
			Sleep(6000);
			continue;
		}

	//check for available_points skill points
	if (.AI)
		while (1) {
			Sleep(250);
			available_points = .AvailableSkillPoints;
			if (available_points <= 0)
				break;
			if (skill_to_develop < 0) {
				.AIGetSkillToDevelop(skill_to_develop, skill_to_develop_level);
				if (skill_to_develop < 0)//maxed skill
					break;
			}
			//already developing a skill
			skill_points = .GetSkill(skill_to_develop);
			if (skill_points >= skill_to_develop_level) {//this case can appear only when any bad guy messes up with the skills on the fly
				skill_to_develop = -1;
				continue;
			}
			else if (skill_points < 0) {
				skill_to_develop = -1;
				continue;
			}
			if (skill_points + available_points < skill_to_develop_level) {
				.SetSkill(skill_to_develop, skill_points + available_points);
				break;
			}
			.SetSkill(skill_to_develop, skill_to_develop_level);
			skill_to_develop = -1;
			skill_to_develop_level = -1;
		}

	.army.ClearDead();
	army_size = .army.count;

	fighting_units_perc = 0;
	healing_weight = 0;//combination of skill gain, skill level and army current health
	charge_weight = 0;//combination of skill gain, skill level and army current stamina
	rush_weight = 0;//combination of skill gain, skill level and army current health and stamina

	healing_skill_level = .GetSkill(hsHealing);
	healing_skill_amount = healing_skill_level * heal_per_level;
	healing_max_amount = healing_skill_amount * army_size;

	charge_skill_level = .GetSkill(hsCharge);
	charge_max_amount = charge_skill_level * army_size;

	rush_skill_level = .GetSkill(hsRush);
	rush_max_amount = rush_skill_level * army_size;

	if (army_size > 0)
		if (.stamina >= 4) {
			Unit u;
			int i, military_units, fighting_units, army_health, army_max_health, healing_amount, army_stamina, army_max_stamina, charge_amount, rush_amount;
			int army_health_perc_multiplier, army_stamina_perc_multiplier;
			bool enemy_in_sight;

			enemy_in_sight = .IsEnemyInSquadSight();

			for (i = 0; i < army_size; i += 1) {
				u = .army[i].AsUnit();
				if (u.IsValid) {
					if (u.IsHeirOf("Military")) {
						military_units += 1;
						if (enemy_in_sight)
							if (u.TimeWithoutAttack <= 2000)
								fighting_units += 1;
					}
					army_health += u.health;
					army_max_health += u.maxhealth;
					healing_amount += MIN(healing_skill_amount, u.maxhealth - u.health);

					army_stamina += u.stamina;
					army_max_stamina += u.maxstamina;
					charge_amount += MIN(charge_skill_level, u.maxstamina - u.stamina);

					if (rush_amount > -1) {
						rush_amount += MIN(rush_skill_level, u.maxstamina - u.stamina);
						if (u.health - rush_skill_level * rush_damage <= 0)//don't let anyone die from the skill (only a human player can understand when it is acceptable)
							rush_amount = -1;
					}
				}
			}
			if (military_units > 0)
				fighting_units_perc = fighting_units * 100 / military_units;

			if (healing_amount > 0) {
				int healing_amount_perc, healing_level_multiplier;
				healing_amount_perc = healing_amount * 100 / healing_max_amount;//skill effectiveness (0-100)
				healing_level_multiplier = 60 + 10 * healing_skill_level;//4 points -> no weight change, 3- -> lower weight, 5+ -> higher weight
				army_health_perc_multiplier = (100 + (80 - army_health * 100 / army_max_health));//80% -> no weight change, 81%+ -> lower weight, 79%- -> higher weight
				healing_weight = healing_amount_perc * healing_level_multiplier / 100 * army_health_perc_multiplier / 100;
			}
			if (charge_amount > 0) {
				int charge_amount_perc, charge_level_multiplier;
				charge_amount_perc = charge_amount * 100 / charge_max_amount;//skill effectiveness (0-100)
				charge_level_multiplier = 70 + 10 * charge_skill_level;//3 points -> no weight change, 2- -> lower weight, 4+ -> higher weight
				army_stamina_perc_multiplier = (100 + (50 - army_stamina * 100 / army_max_stamina));//50% -> no weight change, 51%+ -> lower weight, 49%- -> higher weight
				charge_weight = charge_amount_perc * charge_level_multiplier / 100 * army_stamina_perc_multiplier / 100;
			}
			if (rush_amount > 0) {
				int rush_amount_perc, rush_level_multiplier;
				rush_amount_perc = rush_amount * 100 / rush_max_amount;//skill effectiveness (0-100)
				rush_level_multiplier = 150 - 10 * rush_skill_level;//5 points -> no weight change, 4- -> higher weight, 6+ -> lower weight
				army_health_perc_multiplier = (100 - (90 - army_health * 100 / army_max_health));//80% -> no weight change, 91%+ -> higher weight, 89%- -> lower weight
				army_stamina_perc_multiplier = (100 + (30 - army_stamina * 100 / army_max_stamina));//30% -> no weight change, 31%+ -> lower weight, 29%- -> higher weight
				rush_weight = rush_amount_perc * rush_level_multiplier / 100 * army_health_perc_multiplier / 100 * army_stamina_perc_multiplier / 100;
			}
		}

	if (.stamina >= 4) {
		int weight, tmpWeight;
		str cmd_cry;

		while (1) {
			//Divine grace -> max priority to avoid hero death
			if (.health <= .maxhealth - 100) {
				cmd_cry = "divine_grace";
				if (.health <= 400) {
					weight = 100;
					break;
				}
				else {
					int missing_health_perc;
					missing_health_perc = (.maxhealth - .health) * 100 / .maxhealth;
					weight = missing_health_perc * (75 + missing_health_perc) / 100;//25% -> no weight change, 24%- -> lower weight, 26%+ -> higher weight
				}
			}

			//Ceasefire -> almost max priority to avoid either hero death or army destruction, or to finish capturing a building while under attack
			if (.GetSkill(hsCeasefire) > 0)
				if (!.SkillInEffect(hsCeasefire))
					if (.health <= 400 || .command == "retreat" || .command == "capture" && fighting_units_perc >= 20) {
						cmd_cry = "skill_ceasefire";
						weight = 100;
						break;
					}

			//Healing -> very high priority because it is always extremely powerful
			if (healing_weight > weight) {
				cmd_cry = "skill_healing";
				weight = healing_weight;
			}

			//Charge -> high priority because it can be very useful with most units, although not that much when stamina is already high
			if (charge_weight > weight) {
				cmd_cry = "skill_charge";
				weight = charge_weight;
			}

			//Defensive cry -> good priority because it is a powerful, long and cheap skill
			skill_points = .GetSkill(hsDefensiveCry);
			if (skill_points >= 2)
				if (fighting_units_perc >= 20)
					if (!.SkillInEffect(hsDefensiveCry)) {
						tmpWeight = skill_points * fighting_units_perc / 6;
						if (tmpWeight > weight) {
							cmd_cry = "skill_defensive_cry";
							weight = tmpWeight;
						}
					}

			//Assault -> good priority because it is a very powerful skill, although quite short
			skill_points = .GetSkill(hsAssault);
			if (skill_points >= 3)
				if (fighting_units_perc >= 40)
					if (!.SkillInEffect(hsAssault)) {
						tmpWeight = skill_points * fighting_units_perc / 8;
						if (tmpWeight > weight) {
							cmd_cry = "skill_assault";
							weight = tmpWeight;
						}
					}

			//Battle cry -> medium priority because it can be powerful but it depends partially on the units involved
			skill_points = .GetSkill(hsBattleCry);
			if (skill_points >= 4)
				if (fighting_units_perc >= 60)
					if (!.SkillInEffect(hsBattleCry)) {
						tmpWeight = skill_points * fighting_units_perc / 10;
						if (tmpWeight > weight) {
							cmd_cry = "skill_battle_cry";
							weight = tmpWeight;
						}
					}

			//Frenzy -> low priority because it can be immensely powerful but it is short and depends a lot on the units involved
			skill_points = .GetSkill(hsFrenzy);
			if (skill_points >= 5)
				if (fighting_units_perc >= 80)
					if (!.SkillInEffect(hsFrenzy)) {
						tmpWeight = skill_points * fighting_units_perc / 12;
						if (tmpWeight > weight) {
							cmd_cry = "skill_frenzy";
							weight = tmpWeight;
						}
					}

			//Rush -> lowest priority because it is so situational and risky that it can be considered useless or even harmful
			tmpWeight = rush_weight;
			if (tmpWeight > weight)
				if (rand(5) == 0) {
					cmd_cry = "skill_divine_rush";
					weight = tmpWeight;
				}
			break;
		}

		if (cmd_cry != "")
			if (rand(100) < weight + 35)//if a skill has been chosen, give it at least a 35% chance to be used
				if (.stamina >= GetCmdStaminaCost(cmd_cry)) {
					point pt;
					Obj obj;
					.ExecCmd(cmd_cry, pt, obj, false);
				}
	}
	Sleep(1500);
}
Sleep(10000);