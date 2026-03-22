//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid) {
	int plr;

	plr = .player;

	if (!.InHolder) {
		//this is to avoid damaging units with trample and constantly creating useless visual effects
		.SetSpecial(revenge, false);
		.SetSpecial(spike_armor, false);
		.SetSpecial(defense_skill, false);
		.SetSpecial(defensive_tactics, false);
		.SetSpecial(deflection, false);
		.SetSpecial(determination, false);

		.SetNoAIFlag(true);

		if (IsResearched(plr, "Warrior Tales")) {
			int i, exp;

			if (.AsHero().IsValid) {
				i = 1;
				exp = 10;
			}
			else if (.IsHeirOf("GTridentWarrior")) {
				i = 1;
				exp = 5;
			}
			else {
				i = 3;
				exp = 1;
			}

			if (rand(i) == 0) {
				ObjList ol;
				Unit u;

				ol = ObjsInCircle(.pos, 500, "Military").GetObjList();

				for (i = ol.count - 1; i >= 0; i -= 1) {
					u = ol[i].AsUnit();
					if (u.IsAlive)
						if (u.player == plr) {
							CreateFeedback("Experience", u);
							u.SetExperience(u.experience + exp);
						}
				}
			}
		}
	}

	if (.AsHero().IsValid) {
		if (.inherentlevel > EnvReadInt(plr, "BestHeroLevel"))
			EnvWriteInt(plr, "BestHeroLevel", .inherentlevel);
	}
	else if (.IsHeirOf("IMountaineer")) {
		if (.inherentlevel > EnvReadInt(plr, "BestMountaineerLevel"))
			EnvWriteInt(plr, "BestMountaineerLevel", .inherentlevel);
	}
	else if (.IsHeirOf("RLiberatus")) {
		if (.inherentlevel > EnvReadInt(plr, "BestLiberatusLevel"))
			EnvWriteInt(plr, "BestLiberatusLevel", .inherentlevel);
	}
	else if (.IsHeirOf("TValkyrie")) {
		if (.inherentlevel > EnvReadInt(plr, "BestValkyrieLevel"))
			EnvWriteInt(plr, "BestValkyrieLevel", .inherentlevel);
	}
	else if (.IsHeirOf("HMyrmidon_Javelin"))
		if (.inherentlevel > EnvReadInt(plr, "BestMyrmidonLevel"))
			EnvWriteInt(plr, "BestMyrmidonLevel", .inherentlevel);
}