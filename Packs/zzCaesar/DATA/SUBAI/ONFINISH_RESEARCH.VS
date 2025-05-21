//void, Obj This, bool bCanceled
//cmdparam: [ReqSet, <research>, <explanation>, ReqPlr, <research>, <explanation>, NamePlr, <research>, NameSet, <research>, <value>, SetsPlr, <env>, <value>, SetsSet, <env>, <value>]

Building this;
Settlement set;
str dest, token, name, value;
int player;

this = This.AsBuilding();
set = .settlement;

dest = cmdparam;

player = .player;

if (!GetResearchHack())
	EnvWriteString(this, "researching", "no");//don't mess up the queue if invoked by the research hack

while (dest != "") {
	token = ParseStr(dest, dest);
	if (token == "NamePlr") {
		if (bCanceled) {
			name = ParseStr(dest, dest);
			value = ParseStr(dest, dest);
			if (EnvReadString(player, name) != "researched")
				EnvWriteString(player, name, "");
			if (name == "Tribute") {
				Building th;
				th = EnvReadObj(player, "TributeBuilding");
				if (th.IsValid)
					th.GlobalSpellStop();
			}
		}
		else {
			name = ParseStr(dest, dest);
			value = ParseStr(dest, dest);
			EnvWriteString(player, name, "researched");

			if (name == "Code of Valor") {
				ObjList ol;
				Unit u;
				int i, j;
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i);//filtering here with "IEnchantress" does not always return the units (it happens when player i has no enchantresses independently from whom they are attached to)
					ol.ClearDead();
					for (j = 0; j < ol.count; j += 1) {
						u = ol[j].AsUnit();
						if (u.IsValid)
							if (u.player == player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								if (u.inherentlevel < 8)
									if (u.IsHeirOf("IEnchantress")) {
										u.SetLevel(8);
										if (!u.InHolder)
											CreateFeedback("Experience", u);
									}
					}
				}
			}
			else if (name == "Battle tactics")
				SetExperienceModifier(player, GetConst("BattleTacticsExpModifier"));
			else if (name == "Heroes' Wisdom")
				StartPlayerScript(player, "Data/subai/player_heroes_wisdom.vs");
			else if (name == "Warriors' Wisdom")
				StartPlayerScript(player, "Data/subai/player_warriors_wisdom.vs");
			else if (name == "Nobility") {
				ObjList ol;
				Unit u;
				int i, j;
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i, "Military");
					ol.ClearDead();
					for (j = 0; j < ol.count; j += 1) {
						u = ol[j].AsUnit();
						if (u.IsValid)
							if (u.player == player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								if (u.inherentlevel >= 8)
									if (u.inherentlevel < 12) {
										u.SetLevel(12);
										if (!u.InHolder)
											CreateFeedback("Experience", u);
									}
					}
				}
			}
			else if (name == "Supplies")
				StartPlayerScript(player, "Data/subai/greek_supplies.vs");
			else if (name == "Tribute") {
				Building bld;
				Settlement s;
				ObjList l;
				int i, gametime, time, gold;
				str times, values;

				times = GetConstStr("TributeTimes");
				values = GetConstStr("TributeGold");

				gametime = GetTime();

				while (times != "") {
					int old_gold;
					old_gold = gold;
					time = Str2Int(ParseStr(times, times)) * 60000;
					gold = Str2Int(ParseStr(values, values));
					if (gametime < time) {
						gold = old_gold;
						break;
					}
				}

				l = ClassPlayerObjs("Outpost", player).GetObjList();
				for (i = l.count - 1; i >= 0; i -= 1) {
					bld = l[i].AsBuilding();
					if (bld.IsValid) {
						s = bld.settlement;
						if (s.IsValid) {
							s.SetGold(s.gold + gold);
							s.GoldConverted(gold);
						}
					}
				}
			}
			else if (name == "Statue of Amon-Ra") {
				ObjList ol;
				Unit u;
				int i, j;
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i);
					ol.ClearDead();
					for (j = 0; j < ol.count; j += 1) {
						u = ol[j].AsUnit();
						if (u.IsValid)
							if (u.player == player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								u.RecalcBonuses();
					}
				}
			}
			else if (name == "Statue of Osiris") {
				InvalidateRegenConsts();
				EnvWriteString(player, "Statue of Osiris, father of Horus", "researched");//for AI scripts
			}
			else if (name == "Statue of Isis") {
				InvalidateRegenConsts();
				EnvWriteString(player, "Statue of Isis, mother of Anubis", "researched");//for AI scripts
			}
			else if (name == "Gambler's Test")
				InvalidateDamageFormulaParams();
			else if (name == "Gambler's Luck")
				InvalidateDamageFormulaParams();
			else if (name == "Attack focus")
				InvalidateDamageFormulaParams();
			else if (name == "Learning")
				InvalidateDamageFormulaParams();
			else if (name == "Ferocity")
				InvalidateDamageFormulaParams();
			else if (name == "Mumification") {
				ObjList ol;
				Hero h;
				int i, best_level;
				best_level = EnvReadInt(player, "BestHeroLevel");
				ol = GetPlayerUnits(player, "Hero");
				for (i = 0; i < ol.count; i += 1) {
					h = ol[i].AsHero();
					if (h.IsValid)
						if (h.inherentlevel > best_level)
							best_level = h.inherentlevel;
				}
				EnvWriteInt(player, "BestHeroLevel", best_level);
			}
			else if (name == "Mountain Clan Legacy") {
				ObjList ol;
				Unit u;
				int i, best_level;
				best_level = EnvReadInt(player, "BestMountaineerLevel");
				ol = GetPlayerUnits(player, "IMountaineer");
				for (i = 0; i < ol.count; i += 1) {
					u = ol[i].AsUnit();
					if (u.IsValid)
						if (u.inherentlevel > best_level)
							best_level = u.inherentlevel;
				}
				EnvWriteInt(player, "BestMountaineerLevel", best_level);
			}
			else if (name == "Tribute to Heracles") {
				ObjList ol;
				Unit u;
				int i, j, best_level;
				best_level = EnvReadInt(player, "BestMyrmidonLevel");
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i);//filtering here with "HMyrmidon_Javelin" does not always return the units (it happens when player i has no myrmidons independently from whom they are attached to)
					for (j = 0; j < ol.count; j += 1) {
						u = ol[j].AsUnit();
						if (u.IsValid)
							if (u.player == player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								if (u.inherentlevel > best_level)
									if (u.IsHeirOf("HMyrmidon_Javelin"))
										best_level = u.inherentlevel;
					}
				}
				EnvWriteInt(player, "BestMyrmidonLevel", best_level);
			}
		}
	}
	else if (token == "NameSet") {
		if (bCanceled) {
			name = ParseStr(dest, dest);
			value = ParseStr(dest, dest);
			if (EnvReadString(set, name) != "researched")
				EnvWriteString(set, name, "");
		}
		else {
			name = ParseStr(dest, dest);
			value = ParseStr(dest, dest);
			EnvWriteString(set, name, "researched");
			if (name == "Gambling") {
				ExploreCircle(player, .pos, 3600);
				if (rand(100) < GetConst("GamblingChance")) {
					set.SetGold(set.gold + 5000);
					set.GoldConverted(5000);
					EnvWriteString(set, "LuckyGambling", "yes");//used for AI specific tactic scripts
				}
				else
					set.SetFood(set.food + 400);
			}
			else if (name == "TFights")
				set.SetFood(set.food + 4000);
			else if (name == "People's Assembly")
				set.AddToPopulation(15);
			else if (name == "Olympic Games")
				EnvWriteInt(player, "MaxMyrmidons", MAX(10, EnvReadInt(player, "MaxMyrmidons")));
			else if (name == "RGladiator Shows2")
				set.SetFood(set.food + 800);
			else if (name == "TGrainTrade") {
				set.SetGold(set.gold + 1000);
				set.GoldConverted(1000);
			}
			else if (name == "Food Tax")
				set.SetFoodProduction(set.FoodProduction + GetConst("StrongholdFoodProduction"));
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
				ExploreCircle(player, .pos, 6000);
			else if (name == "Buy map")
				ExploreCircle(player, .pos, 18000);
			else if (name == "Trade Routes") {
				Building b;
				ObjList villages;
				int i;
				villages = ClassPlayerObjs("BaseVillage", player).GetObjList();
				for (i = 0; i < villages.count; i += 1) {
					b = villages[i].AsBuilding();
					if (b.IsValid)
						if (!b.IsBroken())
							b.settlement.SetFood(b.settlement.food + 1000);
				}
			}
			else if (name == "Slavery investment") {
				Building b;
				ObjList villages;
				int i;
				villages = ClassPlayerObjs("BaseVillage", player).GetObjList();
				for (i = 0; i < villages.count; i += 1) {
					b = villages[i].AsBuilding();
					if (b.IsValid)
						if (!b.IsBroken())
							b.settlement.AddToPopulation(10);
				}
				EnvWriteString(set, name, "");//re-enable research
			}
			else if (name == "Strengthen Stronghold Gates") {
				ObjList gates;
				Gate g;
				int i;
				gates = set.ObjectsAround("Gate");
				for (i = 0; i < gates.count; i += 1) {
					g = gates[i].AsGate();
					if (g.IsValid) {
						g.SetMaxHealth(g.maxhealth + g.maxhealth / 2);
						if (!g.IsBroken)
							g.SetHealth(g.maxhealth);
					}
				}
			}
			else if (name == "Slavery") {
				int gold;
				gold = GetConst("SlaveryGold");
				set.SetGold(set.gold + gold);
				set.GoldConverted(gold);
				EnvWriteString(set, name, "");//re-enable research
			}
			else if (name == "Liberati guild") {
				ObjList ol;
				Unit u;
				int i, best_level;
				best_level = EnvReadInt(player, "BestLiberatusLevel");
				ol = GetPlayerUnits(player, "RLiberatus");
				for (i = 0; i < ol.count; i += 1) {
					u = ol[i].AsUnit();
					if (u.IsValid)
						if (u.inherentlevel > best_level)
							best_level = u.inherentlevel;
				}
				EnvWriteInt(player, "BestLiberatusLevel", best_level);
			}
			else if (name == "Legendary Valkyries") {
				ObjList ol;
				Unit u;
				int i, j, best_level;
				best_level = EnvReadInt(player, "BestValkyrieLevel");
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i);//filtering here with "TValkyrie" does not always return the units (it happens when player i has no valkyries independently from whom they are attached to)
					for (j = 0; j < ol.count; j += 1) {
						u = ol[j].AsUnit();
						if (u.IsValid)
							if (u.player == player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								if (u.inherentlevel > best_level)
									if (u.IsHeirOf("TValkyrie"))
										best_level = u.inherentlevel;
					}
				}
				EnvWriteInt(player, "BestValkyrieLevel", best_level);
			}
			else if (name == "Organize tournament") {
				Unit u;
				int i, level;
				bool god_gift;
				level = EnvReadInt(player, "standard_spawn_level");
				god_gift = EnvReadInt(set, "items/God's Gift") == 1;
				for (i = 0; i < 20; i += 1) {
					u = Place("RGladiator", .pos, player);
					u.SetLevel(level);
					u.SetFood(u.maxfood);
					if (god_gift)
						u.AddItem("God's Gift");
					set.ForceAddUnit(u);
				}
				set.SetGold(set.gold + 2000);
				set.GoldConverted(2000);
				EnvWriteString(set, name, "");//re-enable research
			}
			else if (name == "Gambler's All-in") {
				if (rand(100) < GetConst("AllInChance")) {
					set.SetGold(set.gold + 10000);
					set.GoldConverted(10000);
				}
				set.AddToPopulation(40);
				EnvWriteInt(set, "LastAllIn", GetTime());//cooldown
				EnvWriteString(set, name, "");//re-enable research
			}
			else if (name == "Housing") {
				set.AddToMaxPopulation(15);
				set.AddToPopulation(5);
			}
			else if (name == "More Housing") {
				set.AddToMaxPopulation(15);
				set.AddToPopulation(5);
			}
			else if (name == "CLibyanFootman") {
				if (EnvReadString(set, "ResearchedLibyanFootman") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "CJavelinThrower") {
				if (EnvReadString(set, "ResearchedJavelinThrower") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "CBerberAssassin") {
				if (EnvReadString(set, "ResearchedBerberAssassin") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "CMaceman") {
				if (EnvReadString(set, "ResearchedMaceman") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "CNumidianRider") {
				if (EnvReadString(set, "ResearchedNumidianRider") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
			}
			else if (name == "CHorseman")
				if (EnvReadString(set, "ResearchedHorseman") == "yes")
					set.SetGold(set.gold + cmdcost_gold);
		}
	}
	else if (!bCanceled)
		if (token == "SetsPlr") {
			name = ParseStr(dest, dest);
			value = ParseStr(dest, dest);
			if (name == "maxtrainlevel")
				value = "" + MAX(Str2Int(value), Str2Int(EnvReadString(player, name)));
			EnvWriteString(player, name, value);
		}
		else if (token == "SetsSet") {
			name = ParseStr(dest, dest);
			value = ParseStr(dest, dest);
			if (name == "SentriesLevel")
				value = "" + MAX(Str2Int(value), Str2Int(EnvReadString(set, name)));
			EnvWriteString(set, name, value);
		}
}