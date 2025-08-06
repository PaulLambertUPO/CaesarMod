//void, Obj This

int player;

This.AsBuilding().Progress();

player = This.player;

EnvWriteInt(player, "MaxTeutonRiders", EnvReadInt(player, "MaxTeutonRiders") + 10);

EnvWriteString(player, "Increase Horseshoe production", "researched");