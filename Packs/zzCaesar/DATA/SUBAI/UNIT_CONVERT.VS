//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (.InHolder)
			if (.IsHeirOf("TTeutonRider")) {
				if (IsResearched(.player, "Teuton Master"))
					.Mutate("TTeutonArcher");
			}
			else if (.IsHeirOf("TTeutonArcher")) {
				if (IsResearched(.player, "Teuton Master"))
					.Mutate("TTeutonWolf");
			}
			else if (.IsHeirOf("TTeutonWolf")) {
				if (IsResearched(.player, "Teuton Master"))
					.Mutate("TTeutonRider");
			}
			else if (.IsHeirOf("IMilitiaman"))
				if (!.GetHolderSett().GetCentralBuilding().AsCatapult().IsValid)
					.Mutate("IVillager");