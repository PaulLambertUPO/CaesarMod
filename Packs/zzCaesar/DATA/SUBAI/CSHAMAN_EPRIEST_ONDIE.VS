//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (!.InHolder) {
		//this is to avoid damaging units with trample and constantly creating useless visual effects
		.SetSpecial(revenge, false);
		.SetSpecial(spike_armor, false);
		.SetSpecial(defense_skill, false);
		.SetSpecial(defensive_tactics, false);
		.SetSpecial(deflection, false);
		.SetSpecial(determination, false);

		.SetNoAIFlag(true);

		if (IsResearched(.player, "Zombify"))
			if (!.IsSummoningDeath) {
				Unit u;

				u = Place("GGhost", .pos, .player);

				u.SetStamina(5);
				u.SetLevel(.inherentlevel);
				u.SetNoAIFlag(true);
				u.SetCommand("spawn");

				SwapSelectedObj(this, u);
			}
	}