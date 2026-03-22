//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList player_units;
	Unit u;
	int i, j, owning_player;

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	Sleep(GetConst("StonehengeWisdomTime"));

	for (i = 1; i <= 16; i += 1) {
		player_units = GetPlayerUnits(i);
		for (j = player_units.count - 1; j >= 0; j -= 1) {
			u = player_units[j].AsUnit();
			if (u.IsAlive) {
				if (u.inherentlevel < 30) {
					u.SetLevel(u.inherentlevel + 1);
					CreateFeedback("Experience", u);
				}
				if (u.player == owning_player)//check unit player instead of i because GetPlayerUnits takes units from other players that are attached to player i's heroes
					if (u.inherentlevel < 30)
						u.SetExperience(u.experience + 5);
			}
		}
	}
}