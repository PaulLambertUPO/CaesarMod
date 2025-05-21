//void, Obj THIS

Unit this;

this = THIS.AsUnit();

if (.IsValid) {
	//this is to avoid damaging units with trample and constantly creating useless visual effects
	.SetSpecial(revenge, false);
	.SetSpecial(spike_armor, false);
	.SetSpecial(defense_skill, false);
	.SetSpecial(defensive_tactics, false);
	.SetSpecial(deflection, false);
	.SetSpecial(determination, false);

	.SetNoAIFlag(true);

	if (!.IsSentry) {
		int player, exp = 1;

		player = .player;

		if (.AsHero().IsValid) {
			exp = 10;
			if (.inherentlevel > EnvReadInt(player, "BestHeroLevel"))
				EnvWriteInt(player, "BestHeroLevel", .inherentlevel);
		}
		else if (.IsHeirOf("GTridentWarrior"))
			exp = 5;
		else if (.IsHeirOf("IMountaineer")) {
			if (.inherentlevel > EnvReadInt(player, "BestMountaineerLevel"))
				EnvWriteInt(player, "BestMountaineerLevel", .inherentlevel);
		}
		else if (.IsHeirOf("RLiberatus")) {
			if (.inherentlevel > EnvReadInt(player, "BestLiberatusLevel"))
				EnvWriteInt(player, "BestLiberatusLevel", .inherentlevel);
		}
		else if (.IsHeirOf("TValkyrie")) {
			if (.inherentlevel > EnvReadInt(player, "BestValkyrieLevel"))
				EnvWriteInt(player, "BestValkyrieLevel", .inherentlevel);
		}
		else if (.IsHeirOf("HMyrmidon_Javelin"))
			if (.inherentlevel > EnvReadInt(player, "BestMyrmidonLevel"))
				EnvWriteInt(player, "BestMyrmidonLevel", .inherentlevel);

		if (IsResearched(player, "Warrior Tales"))
			if (!.InHolder) {
				int chance = 3;

				if (exp > 1)
					chance = 1;
				if (rand(chance) == 0) {
					Unit u;
					ObjList ol;
					int i;

					ol = ObjsInCircle(.pos, 500, "Military").GetObjList();

					for (i = 0; i < ol.count; i += 1) {
						u = ol[i].AsUnit();
						if (u.IsValid)
							if (player == u.player) {
								CreateFeedback("Experience", u);
								u.SetExperience(u.experience + exp);
							}
					}
				}
			}
	}
}