//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	ObjList player_units;
	Obj o;
	int i, j, k, owning_player;

	owning_player = EnvReadInt(this, "OwningPlayer");

	PlaySound("Data/Sound Entities/StonehengeSpell.xml");

	for (i = GetConst("StonehengeSoothingTime") / 5000; i > 0; i -= 1) {
		for (j = 1; j <= 16; j += 1) {
			player_units = GetPlayerUnits(j);
			for (k = player_units.count - 1; k >= 0; k -= 1) {
				o = player_units[k];
				if (o.IsAlive)
					if (o.stamina < o.maxstamina) {
						if (o.player == owning_player)//check unit player instead of k because GetPlayerUnits takes units from other players that are attached to player k's heroes
							o.HealStamina(10);
						else
							o.HealStamina(5);
						CreateFeedback("StaminaBoost", o.AsUnit());
					}
			}
		}
		Sleep(5000);
	}
}