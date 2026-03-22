//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList owning_player_units, tmp_units;
	Obj o;
	int i, j, owning_player;

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	SetGlobalBloodlust(true);

	for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
		tmp_units = GetPlayerUnits(i, "Military");
		for (j = tmp_units.count - 1; j >= 0; j -= 1) {
			o = tmp_units[j];
			if (o.IsAlive)
				if (o.player == owning_player)//check unit player instead of i because GetPlayerUnits takes units from other players that are attached to player i's heroes
					if (!o.IsRanged)
						owning_player_units.Add(o);
		}
	}

	for (i = owning_player_units.count - 1; i >= 0; i -= 1) {
		o = owning_player_units[i];
		if (o.IsAlive)
			o.AsUnit().AddBonus(6, 0, 0, 0, 0);
	}

	Sleep(GetConst("StonehengeBloodlustTime"));

	SetGlobalBloodlust(false);

	for (i = owning_player_units.count - 1; i >= 0; i -= 1) {
		o = owning_player_units[i];
		if (o.IsAlive)
			o.AsUnit().RemoveBonus(6, 0, 0, 0, 0);
	}
}