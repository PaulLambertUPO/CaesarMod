//void, Obj This, bool bCanceled
//cmdparam: [ReqSet, <research>, <explanation>, ReqPlr, <research>, <explanation>, SetsSet, <env>, <value>, SetsPlr, <env>, <value>, NameSet, <research>, <value>, NamePlr, <research>, <value>]

Building this;
Settlement set;
str dest, token, name, value;
int plr;

this = This.AsBuilding();
set = .settlement;

dest = cmdparam;

plr = .player;

if (!GetResearchHack())
	EnvWriteString(this, "researching", "no");//avoid messing up the queue if invoked by the research hack

while (dest != "") {
	token = ParseStr(dest, dest);
	if (token == "NamePlr") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (bCanceled) {
			if (EnvReadString(plr, name) != "researched")
				EnvWriteString(plr, name, "");
			if (name == "Tribute") {
				Building th;
				th = EnvReadObj(plr, "TributeBuilding");
				if (th.IsValid)
					th.GlobalSpellStop();
			}
			else if (name == "Protection of Apollo")
				HideAnnouncement("ApolloProtectionP" + plr);
		}
		else {
			EnvWriteString(plr, name, "researched");
			if (name == "Code of Valor") {
				ObjList ol;
				Unit u;
				int i, j;
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i);//filtering here with "IEnchantress" does not always return the units (it happens when player i has no enchantresses independently from whom they are attached to)
					for (j = ol.count - 1; j >= 0; j -= 1) {
						u = ol[j].AsUnit();
						if (u.IsAlive)
							if (u.player == plr)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								if (u.inherentlevel < 8)
									if (u.IsHeirOf("IEnchantress")) {
										u.SetLevel(8);
										CreateFeedback("Experience", u);
									}
					}
				}
			}
			else if (name == "Battle tactics")
				SetExperienceModifier(plr, 100);
			else if (name == "Heroes' Wisdom")
				StartPlayerScript(plr, "Data/Subai/Player_Heroes_Wisdom.vs");
			else if (name == "Warriors' Wisdom")
				StartPlayerScript(plr, "Data/Subai/Player_Warriors_Wisdom.vs");
			else if (name == "Supplies")
				StartPlayerScript(plr, "Data/Subai/Greek_Supplies.vs");
			else if (name == "Protection of Apollo")
				StartPlayerScript(plr, "Data/Subai/Apollo_Protection.vs");
			else if (name == "Nobility") {
				ObjList ol;
				Unit u;
				int i, j;
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i, "Military");
					for (j = ol.count - 1; j >= 0; j -= 1) {
						u = ol[j].AsUnit();
						if (u.IsAlive)
							if (u.player == plr)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								if (u.inherentlevel >= 8)
									if (u.inherentlevel < 12) {
										u.SetLevel(12);
										CreateFeedback("Experience", u);
									}
					}
				}
			}
			else if (name == "Tribute") {
				Settlement s;
				ObjList ol;
				int i, gametime, time, gold, old_gold;
				str times, values;

				times = GetConstStr("TributeTimes");
				values = GetConstStr("TributeGold");

				gametime = GetTime();

				while (times != "") {
					old_gold = gold;
					time = Str2Int(ParseStr(times, times)) * 60000;
					gold = Str2Int(ParseStr(values, values));
					if (gametime < time) {
						gold = old_gold;
						break;
					}
				}

				ol = GetSettlements("Outpost", plr);
				for (i = ol.count - 1; i >= 0; i -= 1) {
					s = ol[i].AsBuilding().settlement;
					s.SetGold(s.gold + gold);
					s.GoldConverted(gold);
				}
			}
			else if (name == "Statue of Amon-Ra") {
				ObjList ol;
				Obj o;
				int i, j;
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i);
					for (j = ol.count - 1; j >= 0; j -= 1) {
						o = ol[j];
						if (o.IsAlive)
							if (o.player == plr)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								o.AsUnit().RecalcBonuses();
					}
				}
			}
			else if (name == "Statue of Osiris")
				InvalidateRegenConsts();
			else if (name == "Statue of Isis")
				InvalidateRegenConsts();
			else if (name == "Gambler's Test")
				InvalidateDamageFormulaParams();
			else if (name == "Attack focus")
				InvalidateDamageFormulaParams();
			else if (name == "Learning")
				InvalidateDamageFormulaParams();
			else if (name == "Mumification") {
				ObjList ol;
				Hero h;
				int i, best_level;
				best_level = EnvReadInt(plr, "BestHeroLevel");
				ol = GetPlayerUnits(plr, "Hero");
				for (i = ol.count - 1; i >= 0; i -= 1) {
					h = ol[i].AsHero();
					if (h.inherentlevel > best_level)
						best_level = h.inherentlevel;
				}
				EnvWriteInt(plr, "BestHeroLevel", best_level);
			}
			else if (name == "Mountain Clan Legacy") {
				ObjList ol;
				Unit u;
				int i, best_level;
				best_level = EnvReadInt(plr, "BestMountaineerLevel");
				ol = GetPlayerUnits(plr, "IMountaineer");
				for (i = ol.count - 1; i >= 0; i -= 1) {
					u = ol[i].AsUnit();
					if (u.inherentlevel > best_level)
						best_level = u.inherentlevel;
				}
				EnvWriteInt(plr, "BestMountaineerLevel", best_level);
			}
			else if (name == "Tribute to Heracles") {
				ObjList ol;
				Unit u;
				int i, j, best_level;
				best_level = EnvReadInt(plr, "BestMyrmidonLevel");
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i, "Military");//filtering here with "HMyrmidon_Javelin" does not always return the units (it happens when player i has no myrmidons independently from whom they are attached to)
					for (j = ol.count - 1; j >= 0; j -= 1) {
						u = ol[j].AsUnit();
						if (u.player == plr)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
							if (u.inherentlevel > best_level)
								if (u.IsHeirOf("HMyrmidon_Javelin"))
									best_level = u.inherentlevel;
					}
				}
				EnvWriteInt(plr, "BestMyrmidonLevel", best_level);
			}
		}
	}
	else if (token == "NameSet") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (bCanceled) {
			if (EnvReadString(set, name) != "researched")
				EnvWriteString(set, name, "");
		}
		else {
			EnvWriteString(set, name, "researched");
			if (name == "Gambling") {
				ExploreCircle(plr, .pos, 3600);
				if (rand(5) < 2) {
					set.SetGold(set.gold + 5000);
					set.GoldConverted(5000);
					EnvWriteString(set, "LuckyGambling", "yes");//used for AI specific tactic scripts
				}
				else
					set.SetFood(set.food + 400);
			}
			else if (name == "Tribal fights")
				set.SetFood(set.food + 4000);
			else if (name == "People's Assembly") {
				set.AddToPopulation(15);
				EnvWriteInt(plr, "MaxElephants", MAX(1, EnvReadInt(plr, "MaxElephants")));
			}
			else if (name == "Olympic Games")
				EnvWriteInt(plr, "MaxMyrmidons", MAX(10, EnvReadInt(plr, "MaxMyrmidons")));
			else if (name == "GladiatorShowsFood")
				set.SetFood(set.food + 800);
			else if (name == "Food sale") {
				set.SetGold(set.gold + 1000);
				set.GoldConverted(1000);
			}
			else if (name == "Food Tax")
				set.SetFoodProduction(set.FoodProduction + 10);
			else if (name == "Free Beer")
				set.AddToPopulation(20);
			else if (name == "Free Drinks") {
				set.AddToPopulation(10);
				set.SetFood(set.food + 800);
			}
			else if (name == "Free Trade") {
				if (set.population < set.max_population)
					set.SetPopulation(set.max_population);
			}
			else if (name == "Free Wine")
				ExploreCircle(plr, .pos, 6000);
			else if (name == "Buy map")
				ExploreCircle(plr, .pos, 18000);
			else if (name == "Trade Routes") {
				ObjList villages;
				Building b;
				int i;
				villages = GetSettlements("BaseVillage", plr);
				for (i = villages.count - 1; i >= 0; i -= 1) {
					b = villages[i].AsBuilding();
					if (!b.IsBroken)
						b.settlement.SetFood(b.settlement.food + 1000);
				}
			}
			else if (name == "Slavery investment") {
				ObjList villages;
				Building b;
				int i;
				villages = GetSettlements("BaseVillage", plr);
				for (i = villages.count - 1; i >= 0; i -= 1) {
					b = villages[i].AsBuilding();
					if (!b.IsBroken)
						b.settlement.AddToPopulation(10);
				}
				EnvWriteString(set, name, "");//re-enable research
			}
			else if (name == "Strengthen Stronghold Walls") {
				ObjList buildings;
				Obj o;
				int i;
				buildings = set.Buildings;
				for (i = buildings.count - 1; i >= 0; i -= 1) {
					o = buildings[i];
					if (o.IsHeirOf("Tower")) {
						o.SetMaxHealth(o.maxhealth + o.maxhealth / 2);
						if (!o.AsBuilding().IsBroken)
							o.SetHealth(o.maxhealth);
					}
					else if (o.IsHeirOf("Wall")) {
						o.SetMaxHealth(o.maxhealth + o.maxhealth / 2);
						if (!o.AsBuilding().IsBroken)
							o.SetHealth(o.maxhealth);
					}
					else if (o.IsGate) {
						o.SetMaxHealth(o.maxhealth + o.maxhealth / 2);
						if (!o.AsBuilding().IsBroken)
							o.SetHealth(o.maxhealth);
					}
				}
			}
			else if (name == "Slavery") {
				set.SetGold(set.gold + 1600);
				set.GoldConverted(1600);
				EnvWriteString(set, name, "");//re-enable research
			}
			else if (name == "Liberati guild") {
				ObjList ol;
				Unit u;
				int i, best_level;
				best_level = EnvReadInt(plr, "BestLiberatusLevel");
				ol = GetPlayerUnits(plr, "RLiberatus");
				for (i = ol.count - 1; i >= 0; i -= 1) {
					u = ol[i].AsUnit();
					if (u.inherentlevel > best_level)
						best_level = u.inherentlevel;
				}
				EnvWriteInt(plr, "BestLiberatusLevel", best_level);
			}
			else if (name == "Legendary Valkyries") {
				ObjList ol;
				Unit u;
				int i, j, best_level;
				best_level = EnvReadInt(plr, "BestValkyrieLevel");
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i, "Military");//filtering here with "TValkyrie" does not always return the units (it happens when player i has no valkyries independently from whom they are attached to)
					for (j = ol.count - 1; j >= 0; j -= 1) {
						u = ol[j].AsUnit();
						if (u.player == plr)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
							if (u.inherentlevel > best_level)
								if (u.IsHeirOf("TValkyrie"))
									best_level = u.inherentlevel;
					}
				}
				EnvWriteInt(plr, "BestValkyrieLevel", best_level);
			}
			else if (name == "Organize tournament") {
				Unit u;
				point pt_place;
				int i, u_level;
				bool god_gift;
				u_level = MAX(1, EnvReadInt(plr, "standard_spawn_level"));
				god_gift = EnvReadInt(set, "items/God's Gift") != 0;
				if (set.IsStronghold) {
					pt_place = .pos;
					for (i = 0; i < 20; i += 1) {
						u = Place("RGladiator", pt_place, plr).AsUnit();
						u.SetLevel(u_level);
						if (god_gift)
							u.AddItem("God's Gift");
						set.ForceAddUnit(u);
					}
				}
				else {
					pt_place = set.GetCentralBuilding().GetExitPoint(.pos, false);
					for (i = 0; i < 20; i += 1) {
						u = Place("RGladiator", pt_place, plr).AsUnit();
						u.SetLevel(u_level);
						if (god_gift)
							u.AddItem("God's Gift");
						u.SetCommand("advance", RandomPointInCircle(pt_place, 450));
					}
				}
				set.SetGold(set.gold + 2000);
				set.GoldConverted(2000);
				EnvWriteString(set, name, "");//re-enable research
			}
			else if (name == "Gambler's All-in") {
				if (rand(100) < 35) {
					set.SetGold(set.gold + 10000);
					set.GoldConverted(10000);
				}
				set.AddToPopulation(40);
				EnvWriteInt(set, "LastAllIn", GetTime());//cooldown
				EnvWriteString(set, name, "");//re-enable research
			}
			else if (name == "Housing I") {
				set.AddToMaxPopulation(15);
				set.AddToPopulation(5);
			}
			else if (name == "Housing II") {
				set.AddToMaxPopulation(15);
				set.AddToPopulation(5);
			}
			else if (name == "Forge spears") {
				if (EnvReadString(set, "ResearchedLibyanFootman") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "Forge javelins") {
				if (EnvReadString(set, "ResearchedJavelinThrower") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "Forge swords") {
				if (EnvReadString(set, "ResearchedBerberAssassin") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "Forge maces") {
				if (EnvReadString(set, "ResearchedMaceman") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "Forge pikes") {
				if (EnvReadString(set, "ResearchedNumidianRider") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "Forge shields")
				if (EnvReadString(set, "ResearchedHorseman") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
		}
	}
	else if (!bCanceled)
		if (token == "SetsPlr") {
			name = ParseStr(dest, dest);
			value = ParseStr(dest, dest);
			if (name != "max_battle_level")
				value = "" + MAX(Str2Int(value), Str2Int(EnvReadString(plr, name)));
			EnvWriteString(plr, name, value);
		}
		else if (token == "SetsSet") {
			name = ParseStr(dest, dest);
			value = ParseStr(dest, dest);
			if (name != "SpecializedUnit")
				if (value != "")
					if (value != "yes")
						value = "" + MAX(Str2Int(value), Str2Int(EnvReadString(set, name)));
			EnvWriteString(set, name, value);
		}
}