//bool, Obj This, bool bAdd
//cmdparam: "number_to_train, max_param, class, research"

Building this;
int player, number_to_train, max_units;
str class, dest, research, max_param;

this = This.AsBuilding();

player = .player;

dest = cmdparam;
number_to_train = Str2Int(ParseStr(dest, dest));
max_param = ParseStr(dest, dest);
class = ParseStr(dest, dest);

if (max_param == "elephant")
	max_units = EnvReadInt(player, "MaxElephants") + 1;
else if (max_param == "axemen")
	max_units = EnvReadInt(player, "MaxAxemen");
else if (max_param == "huntress")
	max_units = EnvReadInt(player, "MaxHuntresses");
else if (max_param == "teutonrider")
	max_units = EnvReadInt(player, "MaxTeutonRiders");
else if (max_param == "macemen")
	max_units = EnvReadInt(player, "MaxMacemen");
else if (max_param == "myrmidon")
	max_units = EnvReadInt(player, "MaxMyrmidons");
else if (max_param == "mountaineer")
	max_units = MAX(10, Str2Int(EnvReadString(player, "MaxMountaineers")));
else if (max_param == "liberatus")
	max_units = 20;
else
	max_units = Str2Int(max_param);

if (bAdd) {
	int queued, curr_units;

	queued = EnvReadInt(player, "QueuedBuild/" + class);

	if (max_param == "teutonrider")
		curr_units = number_to_train + Count(player, "TTeutonRider") + Count(player, "TTeutonArcher") + Count(player, "TTeutonWolf") + queued + EnvReadInt(this, "Build/" + class);
	else if (max_param == "liberatus")
		curr_units = number_to_train + Count(player, "RLiberatus") + EnvReadInt(player, "QueuedBuild/RLiberatus") + EnvReadInt(player, "QueuedBuild/RLiberatusPunic") + EnvReadInt(this, "Build/" + class);
	else
		curr_units = number_to_train + Count(player, class) + queued + EnvReadInt(this, "Build/" + class);

	if (curr_units > max_units)
		return false;

	EnvWriteInt(player, "QueuedBuild/" + class, queued + number_to_train);
}
else
	EnvWriteInt(player, "QueuedBuild/" + class, EnvReadInt(player, "QueuedBuild/" + class) - number_to_train);

return true;