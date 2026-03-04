//void, Obj This

Settlement this;

this = This.AsBuilding().settlement;

if (!.IsIndependent) {
	str unit_class, s;

	unit_class = ParseStr(cmdparam, s);

	if (EnvReadString(this, "ENV_TProd") == unit_class)
		unit_class = "";

	EnvWriteString(this, "ENV_TProd", unit_class);
}