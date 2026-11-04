//void, Obj This

Settlement this;

this = This.AsBuilding().settlement;

if (!.IsIndependent) {
	str unit_class;

	unit_class = cmdparam;

	if (EnvReadString(this, "ENV_TProd") == unit_class)
		unit_class = "";

	EnvWriteString(this, "ENV_TProd", unit_class);
}