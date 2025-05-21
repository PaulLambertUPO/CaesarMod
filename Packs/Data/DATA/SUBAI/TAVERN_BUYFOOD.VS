//void, Obj This

Building this;
Settlement set;

this = This.AsBuilding();
set = .settlement;

.Progress(.cmddelay);

set.SetFood(set.food + Str2Int(cmdparam));