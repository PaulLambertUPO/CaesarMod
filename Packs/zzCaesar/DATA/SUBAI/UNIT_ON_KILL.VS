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

			//removing items with their on_kill script messes up the givings below because this script is executed before
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
				if (rand(2) == 0)
					if (.health <= .maxhealth / 5)
						if (IsResearched(plr, "Statue of Zeus")) {
							.Heal(.maxhealth);
							CreateFeedback("Heal", this);
						}

				if (IsResearched(plr, "Statue of Isis"))
					.SetFood(MIN(.food + 2, .maxfood));

				if (this_is_hero || .IsHeirOf("TValkyrie")) {
					if (.inherentlevel + 3 <= vict.inherentlevel)
						if (IsResearched(plr, "Barbaric Tales")) {
							ObjList ol;
							Unit u;
							int i;

							ol = ObjsInCircle(.posRH, 500, "Military").GetObjList();

							for (i = ol.count - 1; i >= 0; i -= 1) {
								u = ol[i].AsUnit();
								if (u.IsAlive)
									if (u.player == plr) {
										u.SetExperience(u.experience + 15);
										CreateFeedback("Experience", u);
									}
							}
						}
				}
				else if (.IsHeirOf("CNoble")) {
					if (IsResearched(plr, "Ferocity")) {
						Hero h;

						h = .hero;

						if (h.IsValid) {
							Item item;
							int gold;

							gold = GetConst("NobleFerocityGold");

							item = h.FindItem("Gold");

							if (item.IsValid)
								item.SetUseCount(item.use_count + gold);
							else if (h.AddItem("Gold")) {
								item = h.FindItem("Gold");
								item.SetUseCount(gold);
							}
						}
					}
				}
				else if (.IsHeirOf("RLiberatus")) {
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
							else if (rand(100) < EnvReadInt(plr, "GamblersDayChance")) {
								.SetLevel(vict.inherentlevel);
								CreateFeedback("Experience", this);
							}
						}
						else if (rand(100) < EnvReadInt(plr, "GamblersDayChance")) {
							.SetLevel(vict.inherentlevel);
							CreateFeedback("Experience", this);
						}

				//this part must be the last for the damage and it replaces the "GetJupiterAngerTarget" function because of its memory leaks
				if (vict.IsHeirOf("RPriest"))
					if (IsResearched(vict.player, "Wrath of Jupiter")) {//do not kill to avoid the "resurrection bug" that occurs when a unit is healed upon dying
						CreateFeedback("Lightning3", this);
						if (this_is_hero)
							.Damage(MIN(40, .health - 1));
						else
							.Damage(MIN(250, .health - 1));
					}
			}
		}
	}