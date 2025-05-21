//int, Settlement set, int idPlayer

if (set.IsStronghold) {
	int Greece, nRace;
	Greece = ImperialRome;
	nRace = set.GetCentralBuilding().race;
	if (GetTime() <= 2000)
		if (set.gold >= 7000) {//use tactic only if starting gold is one of [10000, 2500 + bonus 5, 5000 + bonus 2/5]
			int rnd;
			rnd = rand(4);
			if (nRace == Gaul) {
				if (rnd < 1)
					return TS_GaulTactic;
				if (rnd < 2)
					return TS_GaulTactic2;
				if (rnd < 3)
					return TS_GaulTactic3;
				return TS_GaulTactic4;
			}
			if (nRace == Iberia) {
				if (rnd < 1)
					return TS_IberianTactic;
				if (rnd < 2)
					return TS_IberianTactic2;
				if (rnd < 3)
					return TS_IberianTactic3;
				return TS_IberianTactic4;
			}
			if (nRace == Germany) {
				if (rnd < 1)
					return TS_GermanyTactic;
				if (rnd < 2)
					return TS_GermanyTactic2;
				if (rnd < 3)
					return TS_GermanyTactic3;
				return TS_GermanyTactic4;
			}
			if (nRace == Egypt) {
				if (rnd < 1)
					return TS_EgyptTactic;
				if (rnd < 2)
					return TS_EgyptTactic2;
				if (rnd < 3)
					return TS_EgyptTactic3;
				return TS_EgyptTactic4;
			}
			if (nRace == Britain) {
				if (rnd < 1)
					return TS_BritishTactic;
				if (rnd < 2)
					return TS_BritishTactic2;
				if (rnd < 3)
					return TS_BritishTactic3;
				return TS_BritishTactic4;
			}
			if (nRace == Carthage) {
				if (rnd < 1)
					return TS_CarthageTactic;
				if (rnd < 2)
					return TS_CarthageTactic2;
				if (rnd < 3)
					return TS_CarthageTactic3;
				return TS_CarthageTactic4;
			}
			if (nRace == RepublicanRome) {
				if (EnvReadInt(set, "ChooseRomanRace") != 1) {
					int nRome;
					nRome = rand(3);
					if (nRome == 0)
						set.Research("ChooseRepublicanRome");
					else if (nRome == 1)
						set.Research("ChooseImperialRome");
					else
						set.Research("ChoosePunicRome");
				}
				if (IsResearched(set, "ChooseRepublicanRome")) {
					if (rnd < 1)
						return TS_RRomeTactic;
					if (rnd < 2)
						return TS_RRomeTactic2;
					if (rnd < 3)
						return TS_RRomeTactic3;
					return TS_RRomeTactic4;
				}
				if (IsResearched(set, "ChooseImperialRome")) {
					if (rnd < 1)
						return TS_MRomeTactic;
					if (rnd < 2)
						return TS_MRomeTactic2;
					if (rnd < 3)
						return TS_MRomeTactic3;
					return TS_MRomeTactic4;
				}
				if (IsResearched(set, "ChoosePunicRome")) {
					if (rnd < 1)
						return TS_PRomeTactic;
					if (rnd < 2)
						return TS_PRomeTactic2;
					if (rnd < 3)
						return TS_PRomeTactic3;
					return TS_PRomeTactic4;
				}
			}
			if (nRace == Greece) {
				if (rnd < 1)
					return TS_GreekTactic;
				if (rnd < 2)
					return TS_GreekTactic2;
				if (rnd < 3)
					return TS_GreekTactic3;
				return TS_GreekTactic4;
			}
		}
}
return TS_NONE;