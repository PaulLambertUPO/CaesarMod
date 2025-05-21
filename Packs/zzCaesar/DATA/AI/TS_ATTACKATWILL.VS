//void, Settlement set, ObjList ol, Obj obj, int nParam

//called by specific tactic scripts, this script is used to gain some early experience (it is able to manage any military unit but it's best suited for heroes)

Building hall;
Unit ruin_hero, u;
Query bears, boars, lions, lionesses, horses, wolves, deer, dangerous_enemies;
Query slow_lvl_10_animals, slow_animals, fast_animals, wells, c_outposts, training_camps;
Obj well, curr_target, ruins, outpost_to_farm;
ObjList units_to_farm;
point area_center, pt;
int area_radius_big = 4000, area_radius_small = 2000, i, m;
bool check_ruins = true, use_ruins;

hall = set.GetCentralBuilding();
area_center = hall.pos();

bears = ObjsInCircle(area_center, area_radius_small, "BearUnit");
boars = ObjsInCircle(area_center, area_radius_small, "BoarUnit");
lions = ObjsInCircle(area_center, area_radius_small, "LionMUnit");
lionesses = ObjsInCircle(area_center, area_radius_small, "LionFUnit");
horses = ObjsInCircle(area_center, area_radius_small, "WildHorse");
wolves = ObjsInCircle(area_center, area_radius_small, "WolfUnit");
deer = ObjsInCircle(area_center, area_radius_small, "Deer");

slow_lvl_10_animals = Union(Union(bears, boars), Union(lions, lionesses));
slow_animals = Union(horses, slow_lvl_10_animals);
fast_animals = Union(wolves, deer);

wells = ObjsInCircle(area_center, area_radius_big, "BaseWell");

c_outposts = ObjsInCircle(area_center, area_radius_big, "COutpost");

training_camps = Intersect(Union(ObjsInCircle(area_center, area_radius_big, "IOutpost"), ObjsInCircle(area_center, area_radius_big, "BOutpost")), FriendlyObjs(set.player, "Outpost"));

use_ruins = AIVar(set.player(), AIV_UseRuins) != 0;

SetNoAIFlag(ol, true);

while (ol.count > 0) {
	Sleep(1500);
	ol.ClearDead();
	for (i = 0; i < ol.count; i += 1) {
		u = ol[i].AsUnit();

		if (u.AsHero().IsValid)
			if (u.health <= u.maxhealth - 100)
				if (u.stamina >= 4)
					u.ExecCmd("divine_grace", u.pos, u, false);

		//try to prevent premature death by using healing items
		if (u.health <= 350)
			if (u.HasItem("Healing herbs"))
				u.UseItem("Healing herbs");
			else if (u.HasItem("Healing water"))
				u.UseItem("Healing water");
			else if (u.HasItem("Bag of healing water"))
				u.UseItem("Bag of healing water");
			else if (u.HasItem("Ash of druid heart"))
				u.UseItem("Ash of druid heart");

		if (u.food < 2)
			if (u.HasItem("Rye spikes"))
				u.UseItem("Rye spikes");

		//these units are too tough and/or too dangerous to stay nearby, the check on this query avoids an impossible fight after hunting an animal if there is a neutral outpost nearby
		dangerous_enemies = Union(
			Union(
				Union(ObjsInSight(u, "BHighlander"), ObjsInSight(u, "BJavelineer")),
				Union(ObjsInSight(u, "IDefender"), ObjsInSight(u, "ISlinger"))
			),
			Union(
				Union(ObjsInSight(u, "EGuardian"), ObjsInSight(u, "EAxetrower")),
				Union(
					Union(ObjsInSight(u, "HHoplite"), ObjsInSight(u, "TValkyrie")),
					Union(ObjsInSight(u, "RLiberatus"), ObjsInSight(u, "GTridentWarrior"))
				)
			)
		);

		//try to prevent premature death by going near a well or back to the townhall if there are enemies nearby
		if (u.health <= 800) {
			bool flee = false;
			if (!dangerous_enemies.IsEmpty()) {
				if (u.command == "attack")
					flee = true;
				else if (u.command == "engage")
					flee = true;
			}
			if (!flee)
				if (u.health <= 450)
					if (u.command != "move")
						if (u.IsEnemyInSquadSight())
							flee = true;
			if (flee) {
				m = 1000000;
				if (!wells.IsEmpty()) {
					well = wells.GetObjList().FilterClosest(u.pos, 1)[0];
					m = u.DistTo(well);
				}
				if (m <= u.DistTo(hall)) {//priority to the well
					pt = well.pos - u.pos;
					pt.SetLen(pt.Len + 150);
					pt = pt + u.pos;
					u.SetCommand("move", pt);
					u.AddCommand(false, "idle");
				}
				else
					u.SetCommand("enter", hall);
			}
		}

		if (use_ruins) {
			if (check_ruins)
				if (u.item_count < u.max_items) {
					ruins = FindRuins(area_center, area_radius_big, u.level);
					if (ruins.IsValid) {
						u.SetCommand("enter", ruins);
						ruin_hero = u;
						check_ruins = false;
						continue;
					}
				}
			if (!check_ruins)
				if (u == ruin_hero)
					if (u.command != "enter")
						if (u.command != "sleep")
							check_ruins = true;
		}

		if (u.command == "getitem")
			continue;
		if (u.item_count < u.max_items)
			if (u.GetSquad().TakeNearbyItems(u.sight()))
				continue;
		if (u.command != "idle")
			continue;

		//try to get maximum profit with spoils of war
		if (u.HasItem("Spoils of War")) {
			int spoils;
			for (i = 1; i <= u.items_count; i += 1)
				if (u.GetItem(i).name == "Spoils of War")
					spoils += 1;
			if (spoils >= 3) {
				u.SetCommand("enter", hall);
				continue;
			}
			else if (u.item_count == u.max_items) {
				u.SetCommand("enter", hall);
				continue;
			}
		}

		//try to hunt a level 10 animal if Gambler's Day is researched
		if (u.inherentlevel < 10)
			if (IsResearched(u.player, "Gambler's Day"))
				if (!slow_lvl_10_animals.IsEmpty()) {
					u.SetCommand("attack", slow_lvl_10_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
					continue;
				}
				else if (!wolves.IsEmpty()) {
					u.SetCommand("attack", wolves.GetObjList().FilterClosest(u.pos, 1)[0]);
					continue;
				}

		//farm some exp with animals near the fortress
		if (u.inherentlevel < 3)
			if (!slow_animals.IsEmpty()) {
				u.SetCommand("attack", slow_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
				continue;
			}

		//farm exp by attacking near neutral CMacemen (do not do this with non-hero units to avoid being killed in few seconds by bleeding attack)
		if (u.health >= 750)
			if (u.AsHero().IsValid)
				if (!c_outposts.IsEmpty()) {
					outpost_to_farm = c_outposts.GetObjList().FilterClosest(u.pos, 1)[0];
					units_to_farm = outpost_to_farm.AsBuilding().settlement.ObjectsAround("CMaceman");
					units_to_farm.ClearDead();
					if (units_to_farm.count > 0) {
						u.SetCommand("approach", outpost_to_farm);
						u.AddCommand(false, "engage");
						continue;
					}
				}

		//go to some nearby training camp
		if (u.inherentlevel < 8)
			if (!training_camps.IsEmpty())
				if (!u.InHolder())
					u.SetCommand("enter", training_camps.GetObjList().FilterClosest(u.pos, 1)[0]);
				else {
					str class_name;
					class_name = u.GetHolderSett().GetCentralBuilding().class;
					if (class_name != "BOutpost" && class_name != "IOutpost")
						u.SetCommand("enter", training_camps.GetObjList().FilterClosest(u.pos, 1)[0]);
				}

		//try to hunt a slow/fast animal
		if (u.inherentlevel < 8) {
			if (!slow_animals.IsEmpty()) {
				u.SetCommand("attack", slow_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
				continue;
			}
			if (!fast_animals.IsEmpty()) {
				u.SetCommand("attack", fast_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
				continue;
			}
		}

		//if there is nothing else to do, go home and wait for the tactic script to end
		if (!u.InHolder())
			u.SetCommand("enter", hall);
	}
}

//this script must be terminated by the calling script (a "race_tactic" one) by using AIBreakScript
while (1)
	Sleep(3600000);