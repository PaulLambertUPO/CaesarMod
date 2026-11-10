//void, Obj This, Obj Victim

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Unit vict;

		vict = Victim.AsUnit();

		if (vict.IsValid) {
			int plr;
			bool this_is_hero;

			plr = .player;

			this_is_hero = .AsHero().IsValid;

			.IncKills(1);

			if (rand(3) == 0)
				if (.health < .maxhealth / 3)
					if (IsResearched(plr, "Gambler's Fortune")) {
						.Heal(.maxhealth);
						CreateFeedback("Heal", this);
					}

			if (this_is_hero) {
				if (IsResearched(plr, "Legendary Heroes")) {
					.AddBonus(0, 0, 0, 2, 0);//increase both health and stamina
					.AddBonus(0, 0, 0, -2, 0);//reset values but keep a bonus of 0 in order for RemoveBonus to work
					.RemoveBonus(0, 0, 0, -2, 0);//increase only health by trying to reduce it with a negative value (RemoveBonus does not consider stamina)
				}
				if (IsResearched(plr, "Roman Triumph"))
					if (This.maxstamina < 20) {//the Unit version of maxstamina does not work (it always returns the base value), but the Obj one does
						.AddBonus(0, 0, 0, 1, 0);//increase both health and stamina
						.RemoveBonus(0, 0, 0, 1, 0);//RemoveBonus does not consider stamina
					}
			}
			else {
				if (.IsHeirOf("RChariot")) {
					if (IsResearched(plr, "Roman Triumph"))
						if (This.maxstamina < 20) {//see comments above
						.AddBonus(0, 0, 0, 1, 0);
						.RemoveBonus(0, 0, 0, 1, 0);
					}
				}
				else if (.IsHeirOf("GTridentWarrior"))
					if (IsResearched(plr, "Legendary Heroes")) {
						.AddBonus(0, 0, 0, 20, 0);//see comments above
						.AddBonus(0, 0, 0, -20, 0);
						.RemoveBonus(0, 0, 0, -20, 0);
					}
				if (rand(10) == 0)
					if (IsResearched(plr, "Gambler's Test")) {
						.AddBonus(1, 0, 0, 0, 0);
						CreateFeedback("Frenzy", this);
						CreateFeedback("Frenzy2", this);
					}
			}

			if (IsResearched(plr, "FerocityResearch")) {
				if (.stamina < .maxstamina) {
					.HealStamina(3);
					CreateFeedback("StaminaBoost", this);
				}
				if (.IsHeirOf("CNoble")) {
					Hero h;

					h = .hero;

					if (h.IsAlive)
						if (h.player == plr) {
							Item item;

							item = h.FindItem("Gold");

							if (item.IsValid)
								item.SetUseCount(item.use_count + 10);
							else if (h.AddItem("Gold")) {
								item = h.FindItem("Gold");
								item.SetUseCount(10);
							}
						}
				}
			}

			if (IsResearched(plr, "Statue of Zeus"))
				.Bless();

			if (IsResearched(plr, "Statue of Isis"))
				.SetFood(MIN(.food + 2, .maxfood));

			if (IsResearched(plr, "Barbaric Tales"))
				if (vict.IsMilitary)
					if (.hero.IsAlive)
						if (.hero.SkillInEffect(hsFrenzy)) {
							if (.IsHeirOf("TValkyrie"))
								.AddBonus(2, 0, 0, 0, 0);
							else
								.AddBonus(1, 0, 0, 0, 0);
							.SetExperience(.experience + 2);
							CreateFeedback("Frenzy", this);
							CreateFeedback("Frenzy2", this);
						}

			//removing items with their on_kill script messes up the givings below because this script is executed before
			.RemoveItemsOfType("Charm of Seth");
			.RemoveItemsOfType("Charm of Thoth");
			.RemoveItemsOfType("Charm of Ra");
			.RemoveItemsOfType("Charm of Isis");
			.RemoveItemsOfType("Damage charm");
			.RemoveItemsOfType("Armor charm");
			.RemoveItemsOfType("Health charm");
			.RemoveItemsOfType("Knowledge charm");

			if (.free_item_slots > 0) {
				if (!this_is_hero) {
					if (IsResearched(plr, "Veteran Offence"))
						if (!.HasItem("Veteran Offence"))
							.AddItem("Veteran Offence");

					if (IsResearched(plr, "Veteran Defence"))
						if (!.HasItem("Veteran Defence"))
							.AddItem("Veteran Defence");

					if (IsResearched(plr, "Veteran Health"))
						if (!.HasItem("Veteran Health"))
							.AddItem("Veteran Health");

					if (IsResearched(plr, "Charm of Athena"))
						if (!.HasItem("Charm of Athena"))
							.AddItem("Charm of Athena");

					if (IsResearched(plr, "Charm of Aegle"))
						if (!.HasItem("Charm of Aegle"))
							.AddItem("Charm of Aegle");

					if (.inherentlevel >= 12) {
						if (IsResearched(plr, "Noble Offence"))
							if (!.HasItem("Noble Offence"))
								.AddItem("Noble Offence");

						if (IsResearched(plr, "Noble Defence"))
							if (!.HasItem("Noble Defence"))
								.AddItem("Noble Defence");
					}
				}

				if (IsResearched(plr, "Spoils of war"))//spoils of war are not unique items so they have lower priority
					.AddItem("Spoils of War");
			}

			if (IsResearched(plr, "Path of the dead III")) {
				if (.IsHeirOf("EAnubisWarrior")) {
					if (.inherentlevel < 14) {
						.SetLevel(14);
						CreateFeedback("Experience", this);
					}
				}
				else if (.inherentlevel < 12) {
					.SetLevel(12);
					CreateFeedback("Experience", this);
				}
			}
			else if (IsResearched(plr, "Path of the dead II")) {
				if (.IsHeirOf("EAnubisWarrior")) {
					if (.inherentlevel < 10) {
						.SetLevel(10);
						CreateFeedback("Experience", this);
					}
				}
				else if (.inherentlevel < 8) {
					.SetLevel(8);
					CreateFeedback("Experience", this);
				}
			}
			else if (IsResearched(plr, "Path of the dead I"))
				if (.IsHeirOf("EAnubisWarrior")) {
					if (.inherentlevel < 6) {
						.SetLevel(6);
						CreateFeedback("Experience", this);
					}
				}
				else if (.inherentlevel < 4) {
					.SetLevel(4);
					CreateFeedback("Experience", this);
				}

			if (!vict.IsSentry) {
				if (.IsHeirOf("RLiberatus")) {
					if (IsResearched(plr, "Liberati triumph")) {
						bool vict_is_special = false;

						if (vict.IsHeirOf("RLiberatus"))
							vict_is_special = true;
						else if (vict.IsHeirOf("RChariot"))
							vict_is_special = true;
						else if (vict.IsHeirOf("GTridentWarrior"))
							vict_is_special = true;
						else if (vict.IsHeirOf("BVikingLord"))
							vict_is_special = true;
						else if (vict.IsHeirOf("IMountaineer"))
							vict_is_special = true;
						else if (vict.IsHeirOf("CWarElephant"))
							vict_is_special = true;
						else if (vict.IsHeirOf("EChariot"))
							vict_is_special = true;
						else if (vict.IsHeirOf("TValkyrie"))
							vict_is_special = true;
						else if (vict.IsHeirOf("HMyrmidon_Javelin"))
							vict_is_special = true;

						if (vict_is_special) {
							.Heal(.maxhealth / 2);
							CreateFeedback("Heal", this);
							.SetExperience(.experience + 3);
							CreateFeedback("Experience", this);
						}
					}
				}
				else if (.IsHeirOf("HMyrmidon_Javelin"))
					if (.experience < vict.experience)
						if (IsResearched(plr, "Tribute to Heracles")) {
							.SetExperience(.experience + 2);
							CreateFeedback("Experience", this);
						}

				if (.inherentlevel < vict.inherentlevel)
					if (IsResearched(plr, "Gambler's Day"))
						if (vict.IsHeirOf("BaseAnimal")) {
							if (vict.GetStaminaDecTime() <= 0) {//exclude summoned animals because they can have a really high level (especially Gaul bears/boars)
								.SetLevel(vict.inherentlevel);
								CreateFeedback("Experience", this);
							}
							else if (rand(100) < 45) {
								.SetLevel(vict.inherentlevel);
								CreateFeedback("Experience", this);
							}
						}
						else if (rand(100) < 45) {
							.SetLevel(vict.inherentlevel);
							CreateFeedback("Experience", this);
						}


				//this part must be the last for the damage and it replaces the "GetJupiterAngerTarget" function because of its memory leaks
				if (vict.IsHeirOf("RPriest")) {
					if (IsResearched(vict.player, "Wrath of Jupiter")) {//do not kill to avoid the "resurrection bug" that occurs when a unit is healed upon dying
						CreateFeedback("Lightning3", this);
						.PlaySound("Data/Sound Entities/JupiterAnger.xml");
						if (this_is_hero)
							.Damage(MIN(40, .health - 1));
						else
							.Damage(MIN(250, .health - 1));
					}
				}
				else if (vict.IsHeirOf("EChariot"))
					if (IsResearched(vict.player, "Venomous revenge"))
						.Disease();
			}
		}
	}