//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	int level_limit, owning_player, k, l, c;
	ObjList player_units;
	Unit u;

	level_limit = GetConst("StonehengeWisdomLevelLimit");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	Sleep(GetConst("StonehengeWisdomTime"));

	for (k = 1; k <= 16; k += 1) {
		player_units = GetPlayerUnits(k);
		player_units.ClearDead();
		c = player_units.count;
		for (l = 0; l < c; l += 1) {
			u = player_units[l].AsUnit();
			if (u.IsValid) {
				if (u.inherentlevel < level_limit) {
					u.SetLevel(u.inherentlevel() + 1);
					if (!u.InHolder)
						CreateFeedback("Experience", u);
				}
				if (u.player == owning_player)//check unit player instead of k because GetPlayerUnits takes units from other players that are attached to player k's heroes
					if (u.inherentlevel < level_limit)//check on level is repeated to avoid giving exp after reaching limit
						u.SetExperience(u.experience + 5);
			}
		}
	}
}