//void, Obj this, Obj Victim

if (.IsValid) {
	Unit me;

	me = .AsUnit();

	if (.IsValid)
		if (.IsAlive) {
			Unit vict;

			vict = Victim.AsUnit();

			if (vict.IsValid) {
				bool me_hero, vict_not_sentry;
				int p;

				me_hero = .AsHero().IsValid;
				vict_not_sentry = !vict.IsSentry;

				p = .player;

				//statistics
				me.IncKills(1);

				//Egypt
				me.RemoveItemsOfType("Damage charm");
				me.RemoveItemsOfType("Armor charm");
				me.RemoveItemsOfType("Health charm");
				me.RemoveItemsOfType("Knowledge charm");
				if (IsResearched(p, "Path of the dead III")) {
					if (me.IsHeirOf("EAnubisWarrior")) {
						if (me.inherentlevel < 14) {
							me.SetLevel(14);
							CreateFeedback("Experience", me);
						}
					}
					else if (me.inherentlevel < 12) {
						me.SetLevel(12);
						CreateFeedback("Experience", me);
					}
				}
				else if (IsResearched(p, "Path of the dead II")) {
					if (me.IsHeirOf("EAnubisWarrior")) {
						if (me.inherentlevel < 10) {
							me.SetLevel(10);
							CreateFeedback("Experience", me);
						}
					}
					else if (me.inherentlevel < 8) {
						me.SetLevel(8);
						CreateFeedback("Experience", me);
					}
				}
				else if (IsResearched(p, "Path of the dead I"))
					if (me.IsHeirOf("EAnubisWarrior")) {
						if (me.inherentlevel < 6) {
							me.SetLevel(6);
							CreateFeedback("Experience", me);
						}
					}
					else if (me.inherentlevel < 4) {
						me.SetLevel(4);
						CreateFeedback("Experience", me);
					}
				if (vict_not_sentry)
					if (IsResearched(p, "Statue of Isis, mother of Anubis"))
						me.SetFood(MIN(me.food + 2, me.maxfood));

				//Carthage
				if (IsResearched(p, "Spoils of war"))
					.AddItem("Spoils of War");
				if (IsResearched(p, "Ferocity"))
					if (me.IsHeirOf("CNoble")) {
						Hero h;
						h = me.hero;
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

				//Rome
				if (!me_hero) {
					if (IsResearched(p, "Veteran Offence"))
						if (!.HasItem("Veteran Offence"))
							.AddItem("Veteran Offence");
					if (IsResearched(p, "Veteran Defence"))
						if (!.HasItem("Veteran Defence"))
							.AddItem("Veteran Defence");
					if (IsResearched(p, "Veteran Health"))
						if (!.HasItem("Veteran Health"))
							.AddItem("Veteran Health");
				}
				if (vict_not_sentry)
					if (me.IsHeirOf("RLiberatus"))
						if (IsResearched(p, "Liberati triumph"))
							if (vict.IsHeirOf("RLiberatus") || vict.IsHeirOf("RChariot") || vict.IsHeirOf("GTridentWarrior")
									|| vict.IsHeirOf("BVikingLord") || vict.IsHeirOf("CWarElephant") || vict.IsHeirOf("TValkyrie")
									|| vict.IsHeirOf("EChariot") || vict.IsHeirOf("HMyrmidon_Javelin") || vict.IsHeirOf("IMountaineer")) {
								me.Heal(me.maxhealth / 2);
								CreateFeedback("Heal", me);
								me.SetExperience(me.experience + 3);
								CreateFeedback("Experience", me);
							}

				//Britain
				if (!me_hero)
					if (me.inherentlevel >= 12) {
						if (IsResearched(p, "Noble Offence"))
							if (!.HasItem("Noble Offence"))
								.AddItem("Noble Offence");
						if (IsResearched(p, "Noble Defence"))
							if (!.HasItem("Noble Defence"))
								.AddItem("Noble Defence");
					}
				if (vict_not_sentry)
					if (me.inherentlevel < vict.inherentlevel)
						if (IsResearched(p, "Gambler's Day"))
							if (rand(100) < EnvReadInt(p, "GamblersDayChance")) {
								me.SetLevel(vict.inherentlevel);
								CreateFeedback("Experience", me);
							}

				//Germany
				if (vict_not_sentry)
					if (me_hero || me.IsHeirOf("TValkyrie"))
						if (me.inherentlevel + 3 <= vict.inherentlevel)
							if (IsResearched(p, "Barbaric Tales")) {
								ObjList ol;
								Unit u;
								int i;
								ol = ObjsInCircle(me.pos, 500, "Military").GetObjList();
								for (i = 0; i < ol.count; i += 1) {
									u = ol[i].AsUnit();
									if (u.IsValid)
										if (u.player == p) {
											u.SetExperience(u.experience + 15);
											CreateFeedback("Experience", u);
										}
								}
							}

				//Greece
				if (!me_hero)
					if (me.free_item_slots > 0) {
						if (IsResearched(p, "Charm of Athena"))
							if (!.HasItem("Charm of Athena"))
								.AddItem("Charm of Athena");
						if (IsResearched(p, "Charm of Aegle"))
							if (!.HasItem("Charm of Aegle"))
								.AddItem("Charm of Aegle");
					}
				if (vict_not_sentry) {
					if (me.health <= me.maxhealth / 5)
						if (rand(2) == 0)
							if (IsResearched(p, "Statue of Zeus")) {
								me.Heal(me.maxhealth);
								CreateFeedback("Heal", me);
							}
					if (me.IsHeirOf("HMyrmidon_Javelin"))
						if (me.experience < vict.experience)
							if (IsResearched(p, "Tribute to Heracles")) {
								me.SetExperience(me.experience + 2);
								CreateFeedback("Experience", me);
							}
				}
			}
		}
}