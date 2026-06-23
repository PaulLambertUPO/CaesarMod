//void, Obj This

Building this;
ObjList player_units;
Unit u;
int i, j, caster_player;

this = This.AsBuilding();

caster_player = EnvReadInt(this, "CasterPlayer");

.GlobalSpellStart(gsWindOfWisdom, caster_player);

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
			if (u.player == caster_player)//check unit player instead of i because GetPlayerUnits takes units from other players that are attached to player i's heroes
				if (u.inherentlevel < 30)
					u.SetExperience(u.experience + 5);
		}
	}
}