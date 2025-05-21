//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList owning_player_units, tmp_units;
	Unit u;
	int bonus_damage, owning_player, i, j, c;

	bonus_damage = GetConst("StonehengeBloodlustBonusDamage");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	SetGlobalBloodlust(true);

	for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
		tmp_units = GetPlayerUnits(i, "Military");
		tmp_units.ClearDead();
		c = tmp_units.count;
		for (j = 0; j < c; j += 1) {
			u = tmp_units[j].AsUnit();
			if (u.IsValid)
				if (u.player == owning_player)//check unit player because GetPlayerUnits takes units from other players that are attached to player i's heroes
					owning_player_units.Add(u);
		}
	}
	c = owning_player_units.count;
	for (i = 0; i < c; i += 1) {
		u = owning_player_units[i].AsUnit();
		if (u.IsValid)
			u.AddBonus(bonus_damage, 0, 0, 0, 0);
	}

	Sleep(GetConst("StonehengeBloodlustTime"));

	SetGlobalBloodlust(false);

	owning_player_units.ClearDead();
	c = owning_player_units.count;
	for (i = 0; i < c; i += 1) {
		u = owning_player_units[i].AsUnit();
		if (u.IsValid)
			u.RemoveBonus(bonus_damage, 0, 0, 0, 0);
	}
}