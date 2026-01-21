//void, Obj This

Building this;
Settlement set;
point pos;
int i, radius;
bool first_time_independent;

Sleep(rand(1001) + 500);

this = This.AsBuilding();
set = .settlement;

radius = .radius + 150;
pos = .pos;

//this manages the cases where the outpost returns independent (with adventure sequences) and where it becomes independent because of other neutral units after the first capture
first_time_independent = EnvReadInt(set, "FirstCaptureReward") != 1;

set.SetLoyalty(100);//impossible to capture until the garrison is defeated

if (set.IsIndependent) {
	ObjList all_defenders_1, all_defenders_2, defenders_outside_1, defenders_outside_2, enemies;
	Unit u;
	point pt1, pt2;
	rect rc;
	int j, range, player, old_level_1, old_level_2, end_level_1, end_level_2, start_time_1, start_time_2, interval_1, interval_2, time;
	int defenders_max_1, defenders_max_2, defenders_out_1, defenders_out_2;
	str defenders_class_1, defenders_class_2;

	rc = GetMapRect();

	range = .range;
	player = .player;

	defenders_max_1 = .GetDefendersMax(1);
	defenders_max_2 = .GetDefendersMax(2);

	defenders_out_1 = .GetDefendersOut(1);
	defenders_out_2 = .GetDefendersOut(2);

	defenders_class_1 = .GetDefenderCls(1);
	defenders_class_2 = .GetDefenderCls(2);

	old_level_1 = .GetStartLevel(1);
	old_level_2 = .GetStartLevel(2);

	end_level_1 = .GetEndLevel(1);
	end_level_2 = .GetEndLevel(2);

	if (end_level_1 != old_level_1)
		interval_1 = 3600000 / (end_level_1 - old_level_1);

	if (end_level_2 != old_level_2)
		interval_2 = 3600000 / (end_level_2 - old_level_2);

	start_time_1 = GetTime();
	start_time_2 = start_time_1;

	if (defenders_class_1 != "")
		for (i = 0; i < defenders_max_1; i += 1) {
			u = Place(defenders_class_1, pos, player).AsUnit();
			set.ForceAddUnit(u);
			u.SetFeeding(false);
			u.SetLevel(old_level_1);
			u.SetNoAIFlag(true);
			all_defenders_1.Add(u);
		}
	if (defenders_class_2 != "")
		for (i = 0; i < defenders_max_2; i += 1) {
			u = Place(defenders_class_2, pos, player).AsUnit();
			set.ForceAddUnit(u);
			u.SetFeeding(false);
			u.SetLevel(old_level_2);
			u.SetNoAIFlag(true);
			all_defenders_2.Add(u);
		}

	while (player == .player) {
		//send away enemy units inside
		pt1 = Point(radius, 0);
		pt1.Rot(rand(360));
		set.Units.ObjEnemy(.player).SetCommand("advance", pt1 + pos);

		all_defenders_1.ClearDead();
		all_defenders_2.ClearDead();
		defenders_outside_1.ClearDead();
		defenders_outside_2.ClearDead();

		//increase level
		time = GetTime();
		if (interval_1 > 0)
			if (time - start_time_1 >= interval_1)
				if (old_level_1 + 1 <= end_level_1) {
					start_time_1 = time;
					old_level_1 += 1;
					for (i = all_defenders_1.count - 1; i >= 0; i -= 1) {
						u = all_defenders_1[i].AsUnit();
						if (u.IsValid)
							if (u.inherentlevel < old_level_1)
								u.SetLevel(old_level_1);
					}
				}
		if (interval_2 > 0)
			if (time - start_time_2 >= interval_2)
				if (old_level_2 + 1 <= end_level_2) {
					start_time_2 = time;
					old_level_2 += 1;
					for (i = all_defenders_2.count - 1; i >= 0; i -= 1) {
						u = all_defenders_2[i].AsUnit();
						if (u.IsValid)
							if (u.inherentlevel < old_level_2)
								u.SetLevel(old_level_2);
					}
				}

		enemies = Union(
			Intersect(
				VisibleObjsInSight(this, "Unit"),
				Subtract(
					Intersect(
						ObjsInRange(this, "Unit", range),
						Union(EnemyObjs(player, "Military"), EnemyObjs(player, "BaseMage"))
					),
					EnemyObjs(player, "Sentry")
				)
			),
			Intersect(ObjsInRange(this, "Catapult", range), EnemyObjs(player, "Catapult"))
		).GetObjList();
		if (enemies.count <= 0) {
			//no threat around, command all units that are out to come back in
			defenders_outside_1.SetCommand("enter_tent", this);
			defenders_outside_1.Clear();
			defenders_outside_2.SetCommand("enter_tent", this);
			defenders_outside_2.Clear();
		}
		else {
			//do not allow defenders to wander too far
			for (i = 0; i < defenders_outside_1.count; i += 1) {
				u = defenders_outside_1[i].AsUnit();
				if (.DistTo(u) > range) {
					pt1 = u.pos - pos;
					pt1.SetLen(range / 2);
					pt2 = pt1 + pos;
					pt2.IntoRect(rc);
					u.SetCommand("move", pt2);
					for (j = 0; j < 4; j += 1) {
						pt1.Rot(90);
						pt2 = pt1 + pos;
						pt2.IntoRect(rc);
						u.AddCommand(false, "guardpatrol", pt2);
					}
				}
			}
			for (i = 0; i < defenders_outside_2.count; i += 1) {
				u = defenders_outside_2[i].AsUnit();
				if (.DistTo(u) > range) {
					pt1 = u.pos - pos;
					pt1.SetLen(range / 2);
					pt2 = pt1 + pos;
					pt2.IntoRect(rc);
					u.SetCommand("move", pt2);
					for (j = 0; j < 4; j += 1) {
						pt1.Rot(90);
						pt2 = pt1 + pos;
						pt2.IntoRect(rc);
						u.AddCommand(false, "guardpatrol", pt2);
					}
				}
			}

			//get out more units if needed
			all_defenders_1.ClearDead();
			if (all_defenders_1.count > 0) {
				defenders_outside_1.ClearDead();
				if (defenders_outside_1.count < defenders_out_1)
					for (i = 0; i < all_defenders_1.count && defenders_outside_1.count < defenders_out_1; i += 1) {
						u = all_defenders_1[i].AsUnit();
						if (u.InHolder) {
							defenders_outside_1.Add(u);
							pt1.Set(0, range / 2);
							pt1.Rot(rand(360));
							pt2 = pt1 + pos;
							pt2.IntoRect(rc);
							u.SetCommand("guardadvance", pt2);
							for (j = 0; j < 4; j += 1) {
								pt1.Rot(90);
								pt2 = pt1 + pos;
								pt2.IntoRect(rc);
								u.AddCommand(false, "guardpatrol", pt2);
							}
						}
					}
			}
			all_defenders_2.ClearDead();
			if (all_defenders_2.count > 0) {
				defenders_outside_2.ClearDead();
				if (defenders_outside_2.count < defenders_out_2)
					for (i = 0; i < all_defenders_2.count && defenders_outside_2.count < defenders_out_2; i += 1) {
						u = all_defenders_2[i].AsUnit();
						if (u.InHolder) {
							defenders_outside_2.Add(u);
							pt1.Set(0, range / 2);
							pt1.Rot(rand(360));
							pt2 = pt1 + pos;
							pt2.IntoRect(rc);
							u.SetCommand("guardadvance", pt2);
							for (j = 0; j < 4; j += 1) {
								pt1.Rot(90);
								pt2 = pt1 + pos;
								pt2.IntoRect(rc);
								u.AddCommand(false, "guardpatrol", pt2);
							}
						}
					}
			}

			//handle the capturing (the new owner will be chosen randomly among the players with most units nearby)
			all_defenders_1.ClearDead();
			if (all_defenders_1.count <= 0) {
				all_defenders_2.ClearDead();
				if (all_defenders_2.count <= 0) {
					enemies.ClearDead();
					i = enemies.count;
					if (i > 0) {
						IntArray player_units, players;
						int max, p;
						for (j = 0; j < i; j += 1)
							player_units[enemies[j].player] += 1;//count units per player
						for (i = 1; i <= 16; i += 1) {
							j = player_units[i];
							if (j > 0)
								if (j > max) {//new max found, reset the players to choose from
									max = j;
									players.resize(0);
									players[0] = i;
									p = 1;
								}
								else if (j == max) {//add one more player to choose from
									players[p] = i;
									p += 1;
								}
						}
						if (p > 0)
							.SetPlayer(players[rand(p)]);
					}
				}
			}
		}

		Sleep(1000);
	}

	if (first_time_independent)//spawn peasants for the new player (only once)
		if (!set.IsIndependent) {//avoid giving peasants to possible neutral units coming from other outposts
			j = .player;
			if (.class == "COutpost") {
				for (i = 0; i < 20; i += 1)
					set.ForceAddUnit(Place("CVillager", pos, j).AsUnit());
			}
			else if (.class == "HOutpost")
				for (i = 0; i < 20; i += 1)
					set.ForceAddUnit(Place("HVillager", pos, j).AsUnit());
			EnvWriteInt(set, "FirstCaptureReward", 1);
		}
}
else
	EnvWriteInt(set, "FirstCaptureReward", 1);//if the outpost starts as not independent, never give the reward

{
	Settlement supplied;
	ObjList macemen, hoplites, units_in;
	Wagon wagon;
	Unit u;
	Building suppliedHall;
	point pt;
	int refresh, food_sales, food_income, gold_income, required_gold, min_resource;
	bool is_gold_outpost = false, is_selling_food, is_selling_gold;

	refresh = GetConst("OutpostRefresh");
	food_sales = GetConst("GOutpostFoodSales");
	food_income = GetConst("GOutpostGoldReturn");
	gold_income = GetConst("ROutpostGoldReturn");
	required_gold = GetConst("ROutpostRequiredGold");
	min_resource = GetConst("MinResQtyToTransport");

	if (.class == "ROutpost")
		is_gold_outpost = true;
	else if (.class == "EOutpost")
		is_gold_outpost = true;

	while (1) {
		//send away enemy units inside
		pt = Point(radius, 0);
		pt.Rot(rand(360));
		set.Units.ObjEnemy(.player).SetCommand("advance", pt + pos);

		if (set.IsIndependent) {//this is probably impossible to happen, in that case just restart the script and wait for the player check loop to end
			if (set.supplied.IsValid)
				set.StopSupply();
			return;
		}
		else {
			is_selling_food = EnvReadString(set, "GOutpostSellFood") == "yes";
			is_selling_gold = EnvReadString(set, "GOutpostSellGold") == "yes";
	
			if (!.IsBroken) {
				if (is_selling_food)
					if (set.food >= food_sales) {
						set.SetFood(set.food - food_sales);
						set.SetGold(set.gold + food_income);
						set.GoldConverted(food_income);
					}
				if (is_selling_gold)
					if (set.gold >= food_income) {
						set.SetGold(set.gold - food_income);
						set.SetFood(set.food + food_sales);
					}
				if (is_gold_outpost)
					if (set.gold >= required_gold) {
						set.SetGold(set.gold + gold_income);
						set.GoldConverted(gold_income);
					}
			}

			if (set.supplied == set)
				set.StopSupply();

			supplied = set.supplied;

			if (supplied.IsValid)
				if (!set.IsEnemy(supplied.player)) {
					suppliedHall = supplied.GetCentralBuilding();
	
					if (!is_selling_gold)
						if (set.gold >= min_resource) {
							i = 1000;
							if (is_gold_outpost)
								if (set.gold >= required_gold)
									if (set.gold - required_gold < i)
										i = set.gold - required_gold;//0-999
							if (i >= min_resource) {
								wagon = set.CreateMuleGold(i);
								wagon.SetCommand("unload", suppliedHall);
								wagon.AddCommand(false, "unload", this);//come back if the destination becomes invalid during the travel
							}
						}
					if (!is_selling_food)
						if (set.food >= min_resource) {
							wagon = set.CreateMuleFood(MIN(1000, set.food));
							wagon.SetCommand("unload", suppliedHall);
							wagon.AddCommand(false, "unload", this);//come back if the destination becomes invalid during the travel
						}
	
					macemen.Clear();
					hoplites.Clear();
					units_in = set.Units;
					for (i = 0; i < units_in.count; i += 1) {
						u = units_in[i].AsUnit();
						if (u.IsValid)
							if (u.IsAlive)
								if (!u.GetCommanded())
									if (u.IsHeirOf("CMaceman"))
										macemen.Add(u);
									else if (u.IsHeirOf("HHoplite"))
										hoplites.Add(u);
					}
					if (suppliedHall.IsHeirOf("BaseTownhall")) {
						if (macemen.count >= 5)
							macemen.SetCommand("enter", suppliedHall);
						if (hoplites.count >= 5)
							hoplites.SetCommand("enter", suppliedHall);
					}
					else if (suppliedHall.IsHeirOf("Outpost")) {
						if (macemen.count >= 5)
							macemen.SetCommand("enter", suppliedHall);
						if (hoplites.count >= 5)
							hoplites.SetCommand("enter", suppliedHall);
					}
				}
		}

		Sleep(refresh);
	}
}