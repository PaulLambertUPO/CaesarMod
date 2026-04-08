//bool, Obj This, bool bAdd
//cmdparam: "number_to_train, max_param, unit_class, research, research_building"

Building this;
int plr, number_to_train, max_units;
str dest, max_param, unit_class;

this = This.AsBuilding();

plr = .player;

dest = cmdparam;
number_to_train = Str2Int(ParseStr(dest, dest));
max_param = ParseStr(dest, dest);
unit_class = ParseStr(dest, dest);

if (max_param == "elephant")
	max_units = EnvReadInt(plr, "MaxElephants");
else if (max_param == "axeman")
	max_units = EnvReadInt(plr, "MaxAxemen");
else if (max_param == "huntress")
	max_units = EnvReadInt(plr, "MaxHuntresses");
else if (max_param == "teutonrider")
	max_units = EnvReadInt(plr, "MaxTeutonRiders");
else if (max_param == "maceman")
	max_units = EnvReadInt(plr, "MaxMacemen");
else if (max_param == "myrmidon")
	max_units = EnvReadInt(plr, "MaxMyrmidons");
else if (max_param == "mountaineer")
	max_units = MAX(10, Str2Int(EnvReadString(plr, "MaxMountaineers")));
else if (max_param == "liberatus")
	max_units = 20;
else
	max_units = Str2Int(max_param);

if (bAdd) {
	int queued, curr_units;

	queued = EnvReadInt(plr, "QueuedBuild/" + unit_class);

	if (max_param == "teutonrider")
		curr_units = number_to_train + Count(plr, "TTeutonRider") + Count(plr, "TTeutonArcher") + Count(plr, "TTeutonWolf") + queued;
	else if (max_param == "liberatus")
		curr_units = number_to_train + Count(plr, "RLiberatus") + EnvReadInt(plr, "QueuedBuild/RLiberatus") + EnvReadInt(plr, "QueuedBuild/RLiberatusPunic");
	else
		curr_units = number_to_train + Count(plr, unit_class) + queued;

	if (curr_units > max_units)
		return false;

	EnvWriteInt(plr, "QueuedBuild/" + unit_class, queued + number_to_train);
}
else
	EnvWriteInt(plr, "QueuedBuild/" + unit_class, MAX(0, EnvReadInt(plr, "QueuedBuild/" + unit_class) - number_to_train));

return true;