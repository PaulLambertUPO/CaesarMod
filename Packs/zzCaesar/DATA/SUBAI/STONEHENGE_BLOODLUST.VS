//void, Obj This

Building this;
ObjList caster_player_units, tmp_units;
Obj o;
int i, j, caster_player;

this = This.AsBuilding();

caster_player = EnvReadInt(this, "CasterPlayer");

.GlobalSpellStart(gsBloodlust, caster_player);

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

SetGlobalBloodlust(true);

for (i = 1; i <= 16; i += 1) {//check all players because GetPlayerUnits does not return units attached to other players' heroes
	tmp_units = GetPlayerUnits(i, "Military");
	for (j = tmp_units.count - 1; j >= 0; j -= 1) {
		o = tmp_units[j];
		if (o.IsAlive)
			if (o.player == caster_player)//check unit player instead of i because GetPlayerUnits takes units from other players that are attached to player i's heroes
				if (!o.IsRanged)
					caster_player_units.Add(o);
	}
}

for (i = caster_player_units.count - 1; i >= 0; i -= 1) {
	o = caster_player_units[i];
	if (o.IsAlive)
		o.AsUnit().AddBonus(6, 0, 0, 0, 0);
}

Sleep(GetConst("StonehengeBloodlustTime"));

SetGlobalBloodlust(false);

for (i = caster_player_units.count - 1; i >= 0; i -= 1) {
	o = caster_player_units[i];
	if (o.IsAlive)
		o.AsUnit().RemoveBonus(6, 0, 0, 0, 0);
}