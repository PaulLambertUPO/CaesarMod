//void, Obj This

Unit this;

this = This.AsUnit();

while (!.Stop(1000))
	;

if (.IsHeirOf("IMilitiaman"))
	.Mutate("IVillager");
else if (.IsHeirOf("TTeutonRider"))
	.Mutate("TTeutonArcher");
else if (.IsHeirOf("TTeutonArcher"))
	.Mutate("TTeutonWolf");
else if (.IsHeirOf("TTeutonWolf"))
	.Mutate("TTeutonRider");