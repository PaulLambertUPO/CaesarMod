//void, Settlement set, ObjList ol, Obj obj, int nParam

//called by specific tactic scripts, this script is used to gain some early experience (it is able to manage any military unit but it's best suited for heroes)

Building hall;
Unit ruin_hero, u;
Query wolves, slow_lvl_10_animals, slow_animals, fast_animals;
ObjList wells, villages, c_outposts, training_outposts;
point hall_pos;
int i;
bool check_ruins = true, use_ruins;

hall = set.GetCentralBuilding();
hall_pos = hall.pos;

wolves = Intersect(ObjsInCircle(hall_pos, 2000, "WolfUnit"), EnemyObjs(set.player, "WolfUnit"));
slow_lvl_10_animals = Intersect(ObjsInCircle(hall_pos, 2000, "BearUnit,BoarUnit,LionMUnit,LionFUnit"), EnemyObjs(set.player, "AttackAnimal"));
slow_animals = Union(Intersect(ObjsInCircle(hall_pos, 2000, "WildHorseUnit"), EnemyObjs(set.player, "WildHorseUnit")), slow_lvl_10_animals);
fast_animals = Union(wolves, Intersect(ObjsInCircle(hall_pos, 2000, "DeerUnit"), EnemyObjs(set.player, "DeerUnit")));

wells = ObjsInCircle(hall_pos, 3000, "BaseWell").GetObjList();
villages = ObjsInCircle(hall_pos, 3000, "BaseVillage").GetObjList();
c_outposts = ObjsInCircle(hall_pos, 3000, "COutpost").GetObjList();
training_outposts = ObjsInCircle(hall_pos, 4000, "IOutpost,BOutpost").GetObjList();

use_ruins = AIVar(set.player, AIV_UseRuins) != 0;

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
		if (u.health <= MIN(350, u.maxhealth / 3))
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

		//try to prevent premature death by going near a well or back to the townhall if there are enemies nearby
		if (u.health <= MIN(800, u.maxhealth * 4 / 5)) {
			bool flee = false;
			//these units are too tough/dangerous to stay nearby, avoids an unwinnable fight after hunting an animal if there is a neutral outpost nearby
			if (!VisibleObjsInSight(u, "BHighlander,BJavelineer,IDefender,ISlinger,EGuardian,EAxetrower,HHoplite,TValkyrie,RLiberatus,GTridentWarrior").IsEmpty)
				if (u.command == "attack")
					flee = true;
				else if (u.command == "engage")
					flee = true;
			if (!flee)
				if (u.health <= MIN(450, u.maxhealth / 2))
					if (u.command != "move")
						if (u.command != "enter")//entering ruins and training outposts can be considered as a fleeing move
							if (u.IsEnemyInSquadSight)
								flee = true;
			if (flee) {
				Obj well;
				int m = 1000000;
				if (wells.count > 0) {
					well = wells.FilterClosest(u.pos, 1)[0];
					m = u.DistTo(well);
				}
				if (m <= u.DistTo(hall)) {//priority to the well
					point pt;
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

		if (use_ruins)
			if (check_ruins) {
				if (u.free_item_slots > 0) {
					Obj ruins;
					ruins = FindRuins(hall_pos, 4000, u.inherentlevel);
					if (ruins.IsValid) {
						u.SetCommand("enter", ruins);
						ruin_hero = u;
						check_ruins = false;
						continue;
					}
				}
			}
			else if (u == ruin_hero)
				if (u.command != "enter")
					if (u.command != "sleep")
						check_ruins = true;

		if (u.command == "getitem")
			continue;
		if (u.items_count < u.max_items)
			if (u.GetSquad().TakeNearbyItems(u.sight))
				continue;
		if (u.command != "idle")
			if (u.DistTo(hall) < 4000)//avoid going too far away
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
			else if (u.items_count == u.max_items) {
				u.SetCommand("enter", hall);
				continue;
			}
		}

		//take nearby neutral villages
		if (villages.count > 0) {
			Obj village_to_take;
			village_to_take = villages.ObjPlayer(16).FilterClosest(u.pos, 1)[0];
			if (village_to_take.IsValid) {
				u.SetCommand("approach", village_to_take);
				continue;
			}
		}

		//try to hunt a level 10 animal if Gambler's Day is researched
		if (u.inherentlevel < 10)
			if (IsResearched(u.player, "Gambler's Day"))
				if (!slow_lvl_10_animals.IsEmpty) {
					u.SetCommand("attack", slow_lvl_10_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
					continue;
				}
				else if (!wolves.IsEmpty) {
					u.SetCommand("attack", wolves.GetObjList().FilterClosest(u.pos, 1)[0]);
					continue;
				}

		//farm some exp with animals near the stronghold
		if (u.inherentlevel < 3)
			if (!slow_animals.IsEmpty) {
				u.SetCommand("attack", slow_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
				continue;
			}

		//farm exp by attacking nearby neutral CMacemen (do not do this with non-hero units to avoid being killed in few seconds by bleeding attack)
		if (u.AsHero().IsValid)
			if (u.health >= MIN(750, u.maxhealth * 3 / 4))
				if (c_outposts.count > 0) {
					Obj outpost_to_farm;
					outpost_to_farm = c_outposts.ObjPlayer(15).FilterClosest(u.pos, 1)[0];
					if (outpost_to_farm.IsValid)
						if (outpost_to_farm.AsBuilding().settlement.ObjectsAround("CMaceman").count > 0) {
							u.SetCommand("approach", outpost_to_farm);
							u.AddCommand(false, "engage");
							continue;
						}
				}

		//go to some nearby training outpost
		if (u.inherentlevel < 8)
			if (training_outposts.count > 0)
				if (!u.InHolder) {
					Obj outpost_to_train;
					outpost_to_train = training_outposts.ObjAlly(u.player).FilterClosest(u.pos, 1)[0];
					if (outpost_to_train.IsValid) {
						u.SetCommand("enter", outpost_to_train);
						continue;
					}
				}
				else {
					str class_name;
					class_name = u.GetHolderSett().GetCentralBuilding().class;
					if (class_name != "BOutpost")
						if (class_name != "IOutpost") {
							Obj outpost_to_train;
							outpost_to_train = training_outposts.ObjAlly(u.player).FilterClosest(u.pos, 1)[0];
							if (outpost_to_train.IsValid) {
								u.SetCommand("enter", outpost_to_train);
								continue;
							}
						}
				}

		//try to hunt a slow/fast animal
		if (u.inherentlevel < 8) {
			if (!slow_animals.IsEmpty) {
				u.SetCommand("attack", slow_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
				continue;
			}
			if (!fast_animals.IsEmpty) {
				u.SetCommand("attack", fast_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
				continue;
			}
		}

		//if there is nothing else to do, stay in the stronghold and wait for the tactic script to end
		if (!u.InHolder)
			u.SetCommand("enter", hall);
	}
}

//this script must be terminated by the calling script (a "race_tactic" one) by using AIBreakScript
while (1)
	Sleep(3600000);