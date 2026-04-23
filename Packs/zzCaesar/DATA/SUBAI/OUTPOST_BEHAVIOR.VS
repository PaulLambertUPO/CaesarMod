//void, Obj This

Building this;
Settlement set;
point pt_pos;
int i, rad;
bool first_time_independent;

Sleep(750 + rand(751));

this = This.AsBuilding();
set = .settlement;

rad = .radius + 150;
pt_pos = .pos;

//this manages the cases where the outpost returns independent (with adventure sequences) and where it becomes independent because of other neutral units after the first capture
first_time_independent = EnvReadInt(set, "FirstCaptureReward") != 1;

if (set.IsIndependent) {
	ObjList all_defenders_1, all_defenders_2, defenders_outside_1, defenders_outside_2, enemies;
	Unit u;
	point pt_1, pt_2;
	rect rc;
	int j, plr, rng, rng_half, max_def_out_1, max_def_out_2, old_level_1, old_level_2, end_level_1, end_level_2, start_time_1, start_time_2, interval_1, interval_2;

	rc = GetMapRect();

	plr = .player;
	rng = .range;
	rng_half = rng / 2;

	max_def_out_1 = .GetDefendersOut(1);
	max_def_out_2 = .GetDefendersOut(2);

	old_level_1 = .GetStartLevel(1);
	old_level_2 = .GetStartLevel(2);

	end_level_1 = .GetEndLevel(1);
	end_level_2 = .GetEndLevel(2);

	if (end_level_1 > old_level_1)
		interval_1 = 3600000 / (end_level_1 - old_level_1);

	if (end_level_2 > old_level_2)
		interval_2 = 3600000 / (end_level_2 - old_level_2);

	start_time_1 = GetTime();
	start_time_2 = start_time_1;

	{
		str defenders_class;

		defenders_class = .GetDefenderCls(1);

		if (defenders_class != "")
			for (i = .GetDefendersMax(1); i > 0; i -= 1) {
				u = Place(defenders_class, pt_pos, plr).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetLevel(old_level_1);
				u.SetNoAIFlag(true);
				all_defenders_1.Add(u);
			}

		defenders_class = .GetDefenderCls(2);

		if (defenders_class != "")
			for (i = .GetDefendersMax(2); i > 0; i -= 1) {
				u = Place(defenders_class, pt_pos, plr).AsUnit();
				set.ForceAddUnit(u);
				u.SetFeeding(false);
				u.SetLevel(old_level_2);
				u.SetNoAIFlag(true);
				all_defenders_2.Add(u);
			}
	}

	while (plr == .player) {
		pt_1.Set(rad, 0);
		pt_1.Rot(rand(360));
		set.Units.ObjEnemy(plr).SetCommand("advance", pt_1 + pt_pos);//send away enemy units inside

		if (set.loyalty < 100)
			set.SetLoyalty(100);

		if (interval_1 > 0) {
			j = GetTime();
			if (j - start_time_1 >= interval_1)
				if (old_level_1 < end_level_1) {
					start_time_1 = j;
					old_level_1 += 1;
				}
				else
					interval_1 = 0;
		}
		if (interval_2 > 0) {
			j = GetTime();
			if (j - start_time_2 >= interval_2)
				if (old_level_2 < end_level_2) {
					start_time_2 = j;
					old_level_2 += 1;
				}
				else
					interval_2 = 0;
		}

		for (i = all_defenders_1.count - 1; i >= 0; i -= 1) {
			u = all_defenders_1[i].AsUnit();
			if (u.IsDead)
				all_defenders_1.Remove(u);
			else if (u.inherentlevel < old_level_1)
				u.SetLevel(old_level_1);
		}
		for (i = all_defenders_2.count - 1; i >= 0; i -= 1) {
			u = all_defenders_2[i].AsUnit();
			if (u.IsDead)
				all_defenders_2.Remove(u);
			else if (u.inherentlevel < old_level_2)
				u.SetLevel(old_level_2);
		}

		enemies = Union(
			Intersect(
				VisibleObjsInSight(this, "Military,BaseMage"),
				Subtract(
					Intersect(
						ObjsInRange(this, "Unit", rng),
						Union(EnemyObjs(plr, "Military"), EnemyObjs(plr, "BaseMage"))
					),
					EnemyObjs(plr, "Sentry")
				)
			),
			Intersect(ObjsInRange(this, "Catapult", rng), EnemyObjs(plr, "Catapult"))
		).GetObjList();

		if (enemies.count <= 0) {//no threat around, command all units that are out to come back in
			defenders_outside_1.SetCommand("enter_tent", this);
			defenders_outside_1.Clear();
			defenders_outside_2.SetCommand("enter_tent", this);
			defenders_outside_2.Clear();
		}
		else {
			for (i = defenders_outside_1.count - 1; i >= 0; i -= 1) {//do not allow units to wander too far
				u = defenders_outside_1[i].AsUnit();
				if (u.IsDead)
					defenders_outside_1.Remove(u);
				else if (.DistTo(u) > rng) {
					pt_1 = u.pos - pt_pos;
					pt_1.SetLen(rng_half);
					pt_2 = pt_1 + pt_pos;
					pt_2.IntoRect(rc);
					u.SetCommand("move", pt_2);
					for (j = 0; j < 4; j += 1) {
						pt_1.Rot(90);
						pt_2 = pt_1 + pt_pos;
						pt_2.IntoRect(rc);
						u.AddCommand(false, "guardpatrol", pt_2);
					}
				}
			}
			for (i = defenders_outside_2.count - 1; i >= 0; i -= 1) {
				u = defenders_outside_2[i].AsUnit();
				if (u.IsDead)
					defenders_outside_2.Remove(u);
				else if (.DistTo(u) > rng) {
					pt_1 = u.pos - pt_pos;
					pt_1.SetLen(rng_half);
					pt_2 = pt_1 + pt_pos;
					pt_2.IntoRect(rc);
					u.SetCommand("move", pt_2);
					for (j = 0; j < 4; j += 1) {
						pt_1.Rot(90);
						pt_2 = pt_1 + pt_pos;
						pt_2.IntoRect(rc);
						u.AddCommand(false, "guardpatrol", pt_2);
					}
				}
			}

			for (i = all_defenders_1.count - 1; i >= 0; i -= 1) {//get out more units if needed
				u = all_defenders_1[i].AsUnit();
				if (u.IsDead)
					all_defenders_1.Remove(u);
				else if (defenders_outside_1.count < max_def_out_1)
					if (u.InHolder) {
						defenders_outside_1.Add(u);
						pt_1.Set(0, rng_half);
						pt_1.Rot(rand(360));
						pt_2 = pt_1 + pt_pos;
						pt_2.IntoRect(rc);
						u.SetCommand("guardadvance", pt_2);
						for (j = 0; j < 4; j += 1) {
							pt_1.Rot(90);
							pt_2 = pt_1 + pt_pos;
							pt_2.IntoRect(rc);
							u.AddCommand(false, "guardpatrol", pt_2);
						}
					}
			}
			for (i = all_defenders_2.count - 1; i >= 0; i -= 1) {//get out more units if needed
				u = all_defenders_2[i].AsUnit();
				if (u.IsDead)
					all_defenders_2.Remove(u);
				else if (defenders_outside_2.count < max_def_out_2)
					if (u.InHolder) {
						defenders_outside_2.Add(u);
						pt_1.Set(0, rng_half);
						pt_1.Rot(rand(360));
						pt_2 = pt_1 + pt_pos;
						pt_2.IntoRect(rc);
						u.SetCommand("guardadvance", pt_2);
						for (j = 0; j < 4; j += 1) {
							pt_1.Rot(90);
							pt_2 = pt_1 + pt_pos;
							pt_2.IntoRect(rc);
							u.AddCommand(false, "guardpatrol", pt_2);
						}
					}
			}

			if (all_defenders_1.count <= 0)//handle the capturing (the new player will be chosen randomly among those with most warriors nearby)
				if (all_defenders_2.count <= 0) {
					enemies = enemies.ObjClass("Military");
					enemies.ClearDead();
					i = enemies.count;
					if (i > 0) {
						IntArray player_warriors, players;
						int max, p;
						for (j = 0; j < i; j += 1)
							player_warriors[enemies[j].player] += 1;//count warriors per player
						for (i = 1; i <= 16; i += 1) {
							j = player_warriors[i];
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

		Sleep(1000);
	}

	if (first_time_independent)//spawn peasants for the new player (only once)
		if (!set.IsIndependent) {//avoid giving peasants to possible neutral units coming from other outposts
			j = .player;
			if (.IsHeirOf("COutpost"))
				for (i = 0; i < 20; i += 1)
					set.ForceAddUnit(Place("CVillager", pt_pos, j).AsUnit());
			else if (.IsHeirOf("HOutpost"))
				for (i = 0; i < 20; i += 1)
					set.ForceAddUnit(Place("HVillager", pt_pos, j).AsUnit());
			EnvWriteInt(set, "FirstCaptureReward", 1);
		}
}
else
	EnvWriteInt(set, "FirstCaptureReward", 1);//if the outpost starts as not independent, never give the reward

{
	Settlement supplied;
	Building suppliedHall;
	Wagon wagon;
	ObjList macemen, hoplites, units_in;
	Obj o;
	point pt;
	int refresh, food_sales, food_income, gold_income, required_gold, min_resource;
	bool is_selling_food, is_selling_gold, is_gold_outpost = false;

	refresh = GetConst("OutpostRefresh");
	food_sales = GetConst("GOutpostFoodSales");
	food_income = GetConst("GOutpostGoldReturn");
	gold_income = GetConst("ROutpostGoldReturn");
	required_gold = GetConst("ROutpostRequiredGold");
	min_resource = GetConst("MinResQtyToTransport");

	if (.IsHeirOf("ROutpost"))
		is_gold_outpost = true;
	else if (.IsHeirOf("EOutpost"))
		is_gold_outpost = true;

	while (true) {
		pt.Set(rad, 0);
		pt.Rot(rand(360));
		set.Units.ObjEnemy(.player).SetCommand("advance", pt + pt_pos);//send away enemy units inside

		if (set.IsIndependent) {
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

					if (!is_selling_food) {
						if (set.UnitsCount > 0)//keep some food for the units inside
							i = min_resource;
						else
							i = 0;
						if (set.food >= min_resource + i) {
							wagon = set.CreateMuleFood(MIN(1000, set.food - i));
							wagon.SetCommand("unload", suppliedHall);
							wagon.AddCommand(false, "unload", this);//come back if the destination becomes invalid during the travel
						}
					}
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

					macemen.Clear();
					hoplites.Clear();
					units_in = set.Units;
					for (i = units_in.count - 1; i >= 0; i -= 1) {
						o = units_in[i];
						if (o.IsAlive)
							if (!o.AsUnit().GetCommanded())
								if (o.IsHeirOf("CMaceman"))
									macemen.Add(o);
								else if (o.IsHeirOf("HHoplite"))
									hoplites.Add(o);
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