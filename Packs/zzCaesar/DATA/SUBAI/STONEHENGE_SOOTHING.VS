//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList player_units;
	Unit u;
	int duration, time_step, owning_player, stamina_increase, interval, k, l, c;

	duration = GetConst("StonehengeSoothingTime");
	time_step = GetConst("StonehengeSoothingTimeStep");

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	for (interval = duration / time_step; interval > 0; interval -= 1) {
		for (k = 1; k <= 16; k += 1) {
			player_units = GetPlayerUnits(k);
			player_units.ClearDead();
			c = player_units.count;
			for (l = 0; l < c; l += 1) {
				u = player_units[l].AsUnit();
				if (u.IsValid)
					if (u.stamina < u.maxstamina) {
						if (u.player == owning_player)//check unit player instead of k because GetPlayerUnits takes units from other players that are attached to player k's heroes
							stamina_increase = 10;
						else
							stamina_increase = 5;
						u.HealStamina(stamina_increase);
						if (!u.InHolder)
							CreateFeedback("StaminaBoost", u);
					}
			}
		}
		Sleep(time_step);
	}
}