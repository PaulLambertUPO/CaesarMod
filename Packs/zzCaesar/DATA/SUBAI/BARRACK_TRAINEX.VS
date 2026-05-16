//void, Obj This
//cmdparam: "number_to_train, max_param, unit_class, research, research_building"

Barrack this;

this = This.AsBarrack();

.Progress(.cmddelay * (1000 - EnvReadInt(.settlement, "BarrackTrainTimeDecrease")) / 1000);

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