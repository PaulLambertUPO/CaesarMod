//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList player_units;
	Unit u;
	int duration, time_step, base_damage, owning_player, interval, damage_to_take, k, l, c;

	duration = GetConst("StonehengeSacrificeTime");
	time_step = GetConst("StonehengeSacrificeTimeStep");
	base_damage = GetConst("StonehengeSacrificeDamage");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	for (interval = duration / time_step; interval > 0; interval -= 1) {
		for (k = 1; k <= 16; k += 1) {
			player_units = GetPlayerUnits(k);//filtering here with "BaseMage" does not always return the units (it happens when player k has no mages independently from whom they are attached to)
			player_units.ClearDead();
			c = player_units.count;
			for (l = 0; l < c; l += 1) {
				u = player_units[l].AsUnit();
				if (u.IsValid)
					if (u.IsHeirOf("BaseMage")) {
						if (u.player == owning_player)//check unit player instead of k because GetPlayerUnits takes units from other players that are attached to player k's heroes
							damage_to_take = base_damage / 2;
						else
							damage_to_take = base_damage;
						u.Damage(damage_to_take);
						if (!u.InHolder)
							CreateFeedback("Death", u);
					}
			}
		}
		Sleep(time_step);
	}
}