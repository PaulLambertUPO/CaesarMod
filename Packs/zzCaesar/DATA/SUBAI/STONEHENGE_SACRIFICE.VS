//void, Obj This

Building this;
ObjList player_units;
Obj o;
int i, j, k, caster_player;

this = This.AsBuilding();

caster_player = EnvReadInt(this, "CasterPlayer");

.GlobalSpellStart(gsDivineSacrifice, caster_player);

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

for (i = GetConst("StonehengeSacrificeTime") / 4000; i > 0; i -= 1) {
	for (j = 1; j <= 16; j += 1) {
		player_units = GetPlayerUnits(j);//filtering here with "BaseMage" does not always return the units (it happens when player j has no mages independently from whom they are attached to)
		for (k = player_units.count - 1; k >= 0; k -= 1) {
			o = player_units[k];
			if (o.IsAlive)
				if (o.IsReligious) {
					if (o.player == caster_player)//check unit player instead of j because GetPlayerUnits takes units from other players that are attached to player j's heroes
						o.Damage(20);
					else
						o.Damage(40);
					CreateFeedback("Death", o.AsUnit());
				}
		}
	}
	Sleep(4000);
}