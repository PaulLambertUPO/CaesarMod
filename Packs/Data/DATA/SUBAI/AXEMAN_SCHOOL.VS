//void, Obj This

int player;

This.AsBuilding().Progress();

player = This.player;

EnvWriteInt(player, "MaxAxemen", EnvReadInt(player, "MaxAxemen") + 10);

EnvWriteString(player, "Increase Axe production", "researched");