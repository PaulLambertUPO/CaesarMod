//void, Obj This
//cmdparam: "number_to_train, max_param, unit_class, research, research_building"

Building this;//do not use Barrack to manage arenas

this = This.AsBuilding();

.Progress();

{
	str dest, unit_class;
	int number_to_train;

	dest = cmdparam;
	number_to_train = Str2Int(ParseStr(dest, dest));
	ParseStr(dest, dest);//max_param is not used here
	unit_class = ParseStr(dest, dest);

	EnvWriteString(this, "Build", unit_class);
	EnvWriteInt(this, "Build/" + unit_class, EnvReadInt(this, "Build/" + unit_class) + number_to_train);
}