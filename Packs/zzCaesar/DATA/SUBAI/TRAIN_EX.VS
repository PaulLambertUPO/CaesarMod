//void, Obj This
//cmdparam: "number_to_train, max_param, class, research"

Building this;
str dest, max_param;
int number_to_train;
str class;

this = This.AsBuilding();

dest = cmdparam;
number_to_train = Str2Int(ParseStr(dest, dest));
max_param = ParseStr(dest, dest);
class = ParseStr(dest, dest);

.Progress(.cmddelay);

EnvWriteString(this, "Build", class);
EnvWriteInt(this, "Build/" + class, number_to_train);
EnvWriteInt(.player, "QueuedBuild/" + class, EnvReadInt(.player, "QueuedBuild/" + class) - number_to_train);