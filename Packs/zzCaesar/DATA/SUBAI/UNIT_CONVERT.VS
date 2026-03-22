//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (.InHolder)
			if (.IsHeirOf("TTeutonRider"))
				.Mutate("TTeutonArcher");
			else if (.IsHeirOf("TTeutonArcher"))
				.Mutate("TTeutonWolf");
			else if (.IsHeirOf("TTeutonWolf"))
				.Mutate("TTeutonRider");
			else if (.IsHeirOf("IMilitiaman"))
				if (!.GetHolderSett().GetCentralBuilding().AsCatapult().IsValid)
					.Mutate("IVillager");