//void, Obj This

Hero this;

Sleep(5500 + rand(501));//the big time is to let the AI manage the skill points when the hero is recruited in specific tactic scripts

this = This.AsHero();

if (.IsValid) {
	Obj o;
	point pt;
	str cmd_skill;
	int i, j, k, ai_skill_to_develop_id, ai_skill_to_develop_level, heal_per_level, rush_damage;
	int fighting_units_perc, healing_weight, charge_weight, rush_weight, healing_level, charge_level, rush_level;
	int military_units, fighting_units, army_health, army_max_health, healing_amount, army_stamina, army_max_stamina, charge_amount, rush_amount;
	bool enemy_in_sight;

	ai_skill_to_develop_id = -1;
	ai_skill_to_develop_level = -1;

	heal_per_level = GetConst("HealthPerHealingLevel");
	rush_damage = GetConst("RushDamage");

	while (.IsAlive) {
		if (.AI)
			while (1) {
				Sleep(250);
				i = .AvailableSkillPoints;
				if (i <= 0)
					break;
				if (ai_skill_to_develop_id < 0) {
					.AIGetSkillToDevelop(ai_skill_to_develop_id, ai_skill_to_develop_level);
					if (ai_skill_to_develop_id < 0)//maxed out
						break;
				}
				j = .GetSkill(ai_skill_to_develop_id);
				if (j >= ai_skill_to_develop_level) {
					ai_skill_to_develop_id = -1;
					continue;
				}
				if (j < 0) {
					ai_skill_to_develop_id = -1;
					continue;
				}
				i += j;
				if (i < ai_skill_to_develop_level) {
					.SetSkill(ai_skill_to_develop_id, i);
					break;
				}
				.SetSkill(ai_skill_to_develop_id, ai_skill_to_develop_level);
				ai_skill_to_develop_id = -1;
				ai_skill_to_develop_level = -1;
			}
		else if (!.autocast) {
			Sleep(4000);
			continue;
		}

		if (.stamina >= 4) {
			fighting_units_perc = 0;
			healing_weight = 0;//combination of skill gain, skill level and army current health
			charge_weight = 0;//combination of skill gain, skill level and army current stamina
			rush_weight = 0;//combination of skill gain, skill level and army current health and stamina

			j = .army.count;
			if (j > 0) {
				military_units = 0;
				fighting_units = 0;
				army_health = 0;
				army_max_health = 0;
				healing_amount = 0;
				army_stamina = 0;
				army_max_stamina = 0;
				charge_amount = 0;

				healing_level = .GetSkill(hsHealing);
				charge_level = .GetSkill(hsCharge);
				rush_level = .GetSkill(hsRush);
				if (rush_level <= 0)
					rush_amount = -1;//avoid useless calculations below if the skill is not developed at all
				else
					rush_amount = 0;

				k = healing_level * heal_per_level;//healing amount

				enemy_in_sight = .IsEnemyInSquadSight;

				for (i = 0; i < j; i += 1) {
					o = .army[i];
					if (o.IsAlive) {
						if (o.IsMilitary) {
							military_units += 1;
							if (enemy_in_sight)
								if (o.AsUnit().TimeWithoutAttack <= 2000)
									if (o.command != "capture")
										fighting_units += 1;
						}
						army_health += o.health;
						army_max_health += o.maxhealth;
						healing_amount += MIN(k, o.maxhealth - o.health);

						army_stamina += o.stamina;
						army_max_stamina += o.maxstamina;
						charge_amount += MIN(charge_level, o.maxstamina - o.stamina);

						if (rush_amount > -1) {
							rush_amount += MIN(rush_level, o.maxstamina - o.stamina);
							if (o.health - rush_level * rush_damage <= 0)//don't let anyone die from the skill (only a human player can understand when it is acceptable)
								rush_amount = -1;
						}
					}
				}
				if (military_units > 0)
					fighting_units_perc = fighting_units * 100 / military_units;
				if (healing_amount > 0)
					healing_weight = healing_amount * 100 / (k * j)                 //skill effectiveness (0-100)
						* (60 + 10 * healing_level) / 100                           //4 points -> no weight change, 3- -> lower weight, 5+ -> higher weight
						* (100 + (80 - army_health * 100 / army_max_health)) / 100; //80% -> no weight change, 81%+ -> lower weight, 79%- -> higher weight
				if (charge_amount > 0)
					charge_weight = charge_amount * 100 / (charge_level * j)          //skill effectiveness (0-100)
						* (70 + 10 * charge_level) / 100                              //3 points -> no weight change, 2- -> lower weight, 4+ -> higher weight
						* (100 + (50 - army_stamina * 100 / army_max_stamina)) / 100; //50% -> no weight change, 51%+ -> lower weight, 49%- -> higher weight
				if (rush_amount > 0)
					rush_weight = rush_amount * 100 / (rush_level * j)                //skill effectiveness (0-100)
						* (150 - 10 * rush_level) / 100                               //5 points -> no weight change, 4- -> higher weight, 6+ -> lower weight
						* (100 - (90 - army_health * 100 / army_max_health)) / 100    //80% -> no weight change, 91%+ -> higher weight, 89%- -> lower weight
						* (100 + (30 - army_stamina * 100 / army_max_stamina)) / 100; //30% -> no weight change, 31%+ -> lower weight, 29%- -> higher weight
			}
			
			j = 0;
			cmd_skill = "";
			while (1) {
				if (.health <= .maxhealth - 100) {//Divine grace -> max priority to avoid hero death
					cmd_skill = "divine_grace";
					if (.health <= 400) {
						j = 100;
						break;
					}
					else {
						k = (.maxhealth - .health) * 100 / .maxhealth;
						j = k * (75 + k) / 100;//missing health: 25% -> no weight change, 24%- -> lower weight, 26%+ -> higher weight
					}
				}
				if (.GetSkill(hsCeasefire) > 0)//Ceasefire -> almost max priority to avoid hero/army death or to capture a building while under attack
					if (!.SkillInEffect(hsCeasefire))
						if (.health <= 500) {
							cmd_skill = "skill_ceasefire";
							j = 100;
							break;
						}
						else if (fighting_units_perc >= 20)
							if (.command == "capture") {
								cmd_skill = "skill_ceasefire";
								j = 100;
								break;
							}
				if (healing_weight > j) {//Healing -> very high priority because it is always extremely powerful
					cmd_skill = "skill_healing";
					j = healing_weight;
				}
				if (charge_weight > j) {//Charge -> high priority because it is very useful with most units, although not that much when stamina is already high
					cmd_skill = "skill_charge";
					j = charge_weight;
				}
				if (fighting_units_perc >= 20) {
					i = .GetSkill(hsDefensiveCry);//Defensive cry -> good priority because it is a powerful, long and cheap skill
					if (i >= 2)
						if (!.SkillInEffect(hsDefensiveCry)) {
							k = i * fighting_units_perc / 6;
							if (k > j) {
								cmd_skill = "skill_defensive_cry";
								j = k;
							}
						}
					i = .GetSkill(hsAssault);//Assault -> good priority because it is a very powerful skill, although quite short
					if (i >= 3)
						if (fighting_units_perc >= 40)
							if (!.SkillInEffect(hsAssault)) {
								k = i * fighting_units_perc / 8;
								if (k > j) {
									cmd_skill = "skill_assault";
									j = k;
								}
							}
					i = .GetSkill(hsBattleCry);//Battle cry -> medium priority because it is powerful but it depends on the units involved
					if (i >= 4)
						if (fighting_units_perc >= 60)
							if (!.SkillInEffect(hsBattleCry)) {
								k = i * fighting_units_perc / 10;
								if (k > j) {
									cmd_skill = "skill_battle_cry";
									j = k;
								}
							}
					i = .GetSkill(hsFrenzy);//Frenzy -> low priority because it can be immensely powerful but it depends a lot on the units/specials involved
					if (i >= 5)
						if (fighting_units_perc >= 80)
							if (!.SkillInEffect(hsFrenzy)) {
								k = i * fighting_units_perc / 12;
								if (k > j) {
									cmd_skill = "skill_frenzy";
									j = k;
								}
							}
				}
				i = rush_weight;//Rush -> lowest priority because it can be powerful but it is so situational/risky that it can become useless or even harmful
				if (i > j)
					if (rand(5) == 0) {
						cmd_skill = "skill_divine_rush";
						j = i;
					}
				break;
			}

			if (cmd_skill != "")
				if (rand(100) < j + 35)//if a skill has been chosen, give it at least a 35% chance to be used
					if (.stamina >= GetCmdStaminaCost(cmd_skill))
						.ExecCmd(cmd_skill, pt, o, false);
		}

		Sleep(1500);
	}
}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);