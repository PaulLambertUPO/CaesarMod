//void, Obj This

Building this, hall;
Settlement set;
Unit u;
ObjList ol;
str u_class;
int i, j, plr, build_number, u_level;
point exit_point;
bool is_stronghold, valid_exit_point = true;

Sleep(500 + rand(501));

this = This.AsBuilding();

set = .settlement;
hall = set.GetCentralBuilding();
is_stronghold = set.IsStronghold;
plr = .player;

exit_point = .GetExitPoint(hall.pos, false);
if (exit_point.x == -1) {
	exit_point.Set(0, 0);
	valid_exit_point = false;
}
else if (exit_point.y == -1) {
	exit_point.Set(0, 0);
	valid_exit_point = false;
}

while (true) {
	u_class = EnvReadString(this, "Build");
	build_number = EnvReadInt(this, "Build/" + u_class);

	if (plr != .player) {
		if (build_number > 0) {
			EnvWriteInt(plr, "QueuedBuild/" + u_class, MAX(0, EnvReadInt(plr, "QueuedBuild/" + u_class) - build_number));
			EnvWriteInt(this, "Build/" + u_class, 0);
			build_number = 0;
		}
		plr = .player;
	}

	if (build_number > 0) {
		u_level = MAX(EnvReadInt(plr, "standard_spawn_level"), MAX(EnvReadInt(set, "levels/Warrior"), EnvReadInt(set, "levels/" + u_class)));

		if (u_class == "RLiberatus" || u_class == "RLiberatusPunic") {
			if (IsResearched(set, "Liberati guild"))
				if (build_number % 10 == 0) {
					u_level = MAX(u_level - 1, EnvReadInt(plr, "BestLiberatusLevel"));//-1 is to manage the first recruitment with no units ever owned
					ol = GetPlayerUnits(plr, "RLiberatus");
					for (i = ol.count - 1; i >= 0; i -= 1) {
						u = ol[i].AsUnit();
						if (u.inherentlevel > u_level)
							u_level = u.inherentlevel;
					}
					u_level += 1;
					EnvWriteInt(plr, "BestLiberatusLevel", u_level);
				}
				else {
					i = EnvReadInt(plr, "BestLiberatusLevel");
					if (i > u_level)
						u_level = i;
				}
		}
		else if (u_class == "TValkyrie") {
			if (IsResearched(set, "Legendary Valkyries"))
				if (build_number % 5 == 0) {
					u_level = MAX(u_level - 1, EnvReadInt(plr, "BestValkyrieLevel"));//-1 is to manage the first recruitment with no units ever owned
					for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
						ol = GetPlayerUnits(i, "Military");//filtering here with "TValkyrie" does not always return the units (it happens when player i has no valkyries independently from whom they are attached to)
						for (j = ol.count - 1; j >= 0; j -= 1) {
							u = ol[j].AsUnit();
							if (u.player == plr)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
								if (u.inherentlevel > u_level)
									if (u.IsHeirOf("TValkyrie"))
										u_level = u.inherentlevel;
						}
					}
					u_level += 1;
					EnvWriteInt(plr, "BestValkyrieLevel", u_level);
				}
				else {
					i = EnvReadInt(plr, "BestValkyrieLevel");
					if (i > u_level)
						u_level = i;
				}
		}
		else if (u_class == "IMountaineer") {
			if (IsResearched(plr, "Mountain Clan Legacy")) {
				i = EnvReadInt(plr, "BestMountaineerLevel");
				if (i > u_level)
					u_level = i;
				ol = GetPlayerUnits(plr, "IMountaineer");
				for (i = ol.count - 1; i >= 0; i -= 1) {
					u = ol[i].AsUnit();
					if (u.inherentlevel > u_level)
						u_level = u.inherentlevel;
				}
				EnvWriteInt(plr, "BestMountaineerLevel", u_level);
			}
		}
		else if (u_class == "HMyrmidon_Javelin") {
			if (IsResearched(plr, "Tribute to Heracles")) {
				i = EnvReadInt(plr, "BestMyrmidonLevel");
				if (i > u_level)
					u_level = i;
				for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
					ol = GetPlayerUnits(i, "Military");//filtering here with "HMyrmidon_Javelin" does not always return the units (it happens when player i has no myrmidons independently from whom they are attached to)
					for (j = ol.count - 1; j >= 0; j -= 1) {
						u = ol[j].AsUnit();
						if (u.player == plr)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
							if (u.inherentlevel > u_level)
								if (u.IsHeirOf("HMyrmidon_Javelin"))
									u_level = u.inherentlevel;
					}
				}
				EnvWriteInt(plr, "BestMyrmidonLevel", u_level);
			}
		}
		else if (u_class == "BVikingLord")
			if (IsResearched(set, "Shrine of Thor")) {
				u_level = MAX(u_level, EnvReadInt(plr, "BestVikingLordLevel"));
				if (u_level < 24) {
					EnvWriteInt(set, "levels/BVikingLord", u_level + 2);
					EnvWriteInt(plr, "BestVikingLordLevel", u_level + 2);
				}
			}

		u = Place(u_class, exit_point, plr).AsUnit();
		if (valid_exit_point)
			if (is_stronghold)
				if (EnvReadInt(set, "EnemiesAlert") != 0)
					u.SetCommand("advance_enter", hall);
				else
					u.SetCommand("enter", hall);
			else
				u.SetCommand("advance", hall.GetEnterPoint(u));
		else if (is_stronghold)
			set.ForceAddUnit(u);
		else
			u.SetCommand("advance", hall.pos);

		if (u_level < 12)
			if (IsResearched(set, "Shared Triumph")) {
				i = Count(plr, u_class);
				if (i > 20)
					u_level = 12;
				else if (i > 10)
					if (u_level < 6)
						if (IsResearched(set, "Shared Strength"))
							u_level = 6;
			}
			else if (u_level < 6)
				if (IsResearched(set, "Shared Strength"))
					if (Count(plr, u_class) > 10)
						u_level = 6;

		u.SetLevel(MAX(1, u_level));

		if (u_class == "Caesar")
			PlaySound("Data/Sound Entities/Completed_Caesar.xml");
		else if (u_class == "Keltill")
			PlaySound("Data/Sound Entities/Completed_Keltill.xml");
		else if (u_class == "Larax") {
			u.AddItem("Chosen One's Gem");
			PlaySound("Data/Sound Entities/Completed_Larax.xml");
		}
		else {
			if (EnvReadInt(set, "items/Bear teeth amulet") != 0)
				u.AddItem("Bear teeth amulet");
			if (EnvReadInt(set, "items/Belt of might") != 0)
				u.AddItem("Belt of might");
			if (EnvReadInt(set, "items/Herb amulet of luck") != 0)
				u.AddItem("Herb amulet of luck");
			if (EnvReadInt(set, "items/God's Gift") != 0)
				u.AddItem("God's Gift");
			if (EnvReadInt(set, "items/Veteran Guild") != 0)
				u.AddItem("Veteran Guild");
		}

		EnvWriteInt(this, "Build/" + u_class, MAX(0, build_number - 1));
		EnvWriteInt(plr, "QueuedBuild/" + u_class, MAX(0, EnvReadInt(plr, "QueuedBuild/" + u_class) - 1));
	}

	Sleep(1000);
}