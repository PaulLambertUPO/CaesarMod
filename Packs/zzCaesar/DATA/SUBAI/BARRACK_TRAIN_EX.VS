//void, Obj This
//cmdparam: "number_to_train, max_param, class, research, research_building"

Building this;
str dest, max_param;
int number_to_train;
str class;

this = This.AsBuilding();

dest = cmdparam;
number_to_train = Str2Int(ParseStr(dest, dest));
max_param = ParseStr(dest, dest);
class = ParseStr(dest, dest);

.Progress(.cmddelay * (1000 - EnvReadInt(.settlement, "BarrackTrainTimeDecrease")) / 1000);

EnvWriteString(this, "Build", class);
EnvWriteInt(this, "Build/" + class, EnvReadInt(this, "Build/" + class) + number_to_train);