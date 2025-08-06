//void, Obj This

int player;

This.AsBuilding().Progress();

player = This.player;

EnvWriteInt(player, "MaxMacemen", EnvReadInt(player, "MaxMacemen") + 10);

EnvWriteString(player, "Increase Mace production", "researched");