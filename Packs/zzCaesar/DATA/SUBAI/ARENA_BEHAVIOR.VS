//void, Obj This

Building this, hall;
Settlement set;
Unit new_unit;
ObjList ol;
str class;
int build_number, player, level;
point exit_point;

this = This.AsBuilding();

set = .settlement;
hall = set.GetCentralBuilding();

Sleep(rand(1000) + 500);

while (1) {
	class = EnvReadString(this, "Build");
	build_number = EnvReadInt(this, "Build/" + class);

	if (build_number > 0) {
		player = .player;
		level = EnvReadInt(set, "levels/" + class);
		exit_point = .GetExitPoint(hall.pos, false);

		if (build_number == 10) {
			if (class == "RLiberatus" || class == "RLiberatusPunic")
				if (IsResearched(set, "Liberati guild")) {
					Unit u;
					int best_level, i;
					best_level = EnvReadInt(player, "BestLiberatusLevel");
					ol = GetPlayerUnits(player, "RLiberatus");
					for (i = 0; i < ol.count; i += 1) {
						u = ol[i].AsUnit();
						if (u.IsValid)
							if (u.inherentlevel > best_level)
								best_level = u.inherentlevel;
					}
					level = MAX(best_level, level) + 1;
					EnvWriteInt(set, "levels/" + class, level);
					EnvWriteInt(player, "BestLiberatusLevel", level);
				}
		}
		else if (build_number == 5) {
			if (class == "TValkyrie")
				if (IsResearched(set, "Legendary Valkyries")) {
					Unit u;
					int best_level, i, j;
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
					level = MAX(best_level, level) + 1;
					EnvWriteInt(set, "levels/TValkyrie", level);
					EnvWriteInt(player, "BestValkyrieLevel", level);
				}
		}
		else if (class == "IMountaineer") {
			if (IsResearched(player, "Mountain Clan Legacy")) {
				Unit u;
				int best_level, i;
				best_level = EnvReadInt(player, "BestMountaineerLevel");
				ol = GetPlayerUnits(player, "IMountaineer");
				for (i = 0; i < ol.count; i += 1) {
					u = ol[i].AsUnit();
					if (u.IsValid)
						if (u.inherentlevel > best_level)
							best_level = u.inherentlevel;
				}
				level = MAX(best_level, level);
				EnvWriteInt(set, "levels/IMountaineer", level);
				EnvWriteInt(player, "BestMountaineerLevel", level);
			}
		}
		else if (class == "HMyrmidon_Javelin") {
			if (IsResearched(player, "Tribute to Heracles")) {
				Unit u;
				int best_level, i, j;
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
				level = MAX(best_level, level);
				EnvWriteInt(set, "levels/HMyrmidon_Javelin", level);
				EnvWriteInt(player, "BestMyrmidonLevel", level);
			}
		}
		else if (class == "BVikingLord")
			if (IsResearched(set, "Shrine of Thor")) {
				level = MAX(level, EnvReadInt(player, "BVikingLordLevel"));
				if (level < 24) {
					EnvWriteInt(set, "levels/BVikingLord", level + 2);
					EnvWriteInt(player, "BVikingLordLevel", level + 2);
				}
			}

		level = MAX(level, EnvReadInt(player, "standard_spawn_level"));

		if (exit_point.x == -1 && exit_point.y == -1) {
			new_unit = Place(class, Point(0, 0), player);
			set.AddUnit(new_unit);
		}
		else {
			new_unit = Place(class, exit_point, player);
			new_unit.SetCommand("advanceenter", hall);
		}
		new_unit.SetLevel(level);

		if (class == "Caesar")
			PlaySound("Data/Sound Entities/Completed_Caesar.xml");
		else if (class == "Keltill")
			PlaySound("Data/Sound Entities/Completed_Keltill.xml");
		else if (class == "Larax") {
			new_unit.AddItem("Chosen One's Gem");
			PlaySound("Data/Sound Entities/Completed_Larax.xml");
		}
		else if (!new_unit.IsHeirOf("BaseMage"))
			if (!new_unit.IsHeirOf("Hero")) {
				if (EnvReadInt(set, "items/Bear teeth amulet") == 1)
					new_unit.AddItem("Bear teeth amulet");
				if (EnvReadInt(set, "items/Belt of might") == 1)
					new_unit.AddItem("Belt of might");
				if (EnvReadInt(set, "items/Herb amulet of luck") == 1)
					new_unit.AddItem("Herb amulet of luck");
				if (EnvReadInt(set, "items/God's Gift") == 1)
					new_unit.AddItem("God's Gift");
				if (EnvReadInt(set, "items/Veteran Guild") == 1)
					new_unit.AddItem("Veteran Guild");
			}

		EnvWriteInt(this, "Build/" + class, build_number - 1);
	}
	Sleep(1000);
}