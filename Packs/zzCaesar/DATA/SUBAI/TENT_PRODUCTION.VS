//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid)
	if (!.settlement.IsIndependent) {
		str class, dest;

		class = ParseStr(cmdparam, dest);

		EnvWriteString(.settlement, "ENV_TProd", class);
	}